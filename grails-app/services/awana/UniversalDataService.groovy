package awana

import grails.gorm.transactions.Transactional
import grails.databinding.DataBinder
import grails.databinding.SimpleMapDataBindingSource
import javax.persistence.PersistenceException

@Transactional
class UniversalDataService {

    DataBinder grailsWebDataBinder

    // ====================================================================
    // USER-SPECIFIC METHODS FOR SPRING SECURITY INTEGRATION
    // ====================================================================

    /**
     * Update user's role by removing all existing roles and assigning new role
     */
    def updateUserRole(User user, Role newRole) {
        try {
            if (user && newRole) {
                // Remove all existing user roles
                UserRole.findAllByUser(user).each { userRole ->
                    userRole.delete(failOnError: true)
                }
                // Assign new role
                UserRole.create(user, newRole)
                return true
            }
        } catch (Exception e) {
            log.error("Error updating user role for user ${user?.username}: ${e.message}")
            return false
        }
        return false
    }

    /**
     * Create a new user with specified role
     */
    def createUserWithRole(Map params, Role role) {
        try {
            def user = save(User, params)
            if (user && role) {
                UserRole.create(user as User, role)
                return user
            }
        } catch (Exception e) {
            log.error("Error creating user with role: ${e.message}")
            return null
        }
        return null
    }

    /**
     * Delete user and all associated roles
     */
    def deleteUser(User user) {
        try {
            if (user) {
                // Remove all user roles first
                UserRole.findAllByUser(user).each { userRole ->
                    userRole.delete(failOnError: true)
                }
                // Delete the user
                user.delete(failOnError: true)
                return true
            }
        } catch (Exception e) {
            log.error("Error deleting user ${user?.username}: ${e.message}")
            return false
        }
        return false
    }

    // ====================================================================
    // CORE CRUD OPERATIONS - COMPLETELY AGNOSTIC
    // ====================================================================

    /**
     * Get instance by ID - works with any domain class
     */
    def getById(Class domainClass, Long id) {
        try {
            return domainClass.get(id)
        } catch (Exception e) {
            log.error("Error retrieving ${domainClass.simpleName} with ID ${id}: ${e.message}")
            return null
        }
    }

    /**
     * List all instances - works with any domain class
     */
    List list(Class domainClass) {
        try {
            return domainClass.list()
        } catch (Exception e) {
            log.error("Error listing ${domainClass.simpleName}: ${e.message}")
            return []
        }
    }

    /**
     * Count all instances - works with any domain class
     */
    Integer count(Class domainClass) {
        try {
            return domainClass.count()
        } catch (Exception e) {
            log.error("Error counting ${domainClass.simpleName}: ${e.message}")
            return 0
        }
    }

    /**
     * Save new instance - completely agnostic
     */
    def save(Class domainClass, Map params) {
        try {
            def instance = domainClass.newInstance()
            if (instance) {
                updateProperties(instance, params)
                instance.save(failOnError: true)
                return instance
            }
        } catch (PersistenceException e) {
            log.error("Persistence error saving ${domainClass.simpleName}: ${e.message}")
            return null
        } catch (Exception e) {
            log.error("Error saving ${domainClass.simpleName}: ${e.message}")
            return null
        }
        return null
    }

    /**
     * Update existing instance - completely agnostic
     */
    def update(Class domainClass, Long id, Map params) {
        try {
            def instance = getById(domainClass, id)
            if (instance) {
                updateProperties(instance, params)
                instance.save(failOnError: true)
                return instance
            } else {
                log.warn("${domainClass.simpleName} with ID ${id} not found for update")
            }
        } catch (PersistenceException e) {
            log.error("Persistence error updating ${domainClass.simpleName} with ID ${id}: ${e.message}")
            return null
        } catch (Exception e) {
            log.error("Error updating ${domainClass.simpleName} with ID ${id}: ${e.message}")
            return null
        }
        return null
    }

    /**
     * Delete instance by ID - completely agnostic
     */
    def deleteById(Class domainClass, Long id) {
        try {
            def instance = getById(domainClass, id)
            if (instance) {
                instance.delete(failOnError: true)
                return true
            } else {
                log.warn("${domainClass.simpleName} with ID ${id} not found for deletion")
                return false
            }
        } catch (Exception e) {
            log.error("Error deleting ${domainClass.simpleName} with ID ${id}: ${e.message}")
            return false
        }
    }

    // ====================================================================
    // ADVANCED QUERYING - PAGINATED AND SEARCHABLE
    // ====================================================================

    /**
     * Advanced paginated listing with search and filtering
     * Completely agnostic - works with any domain class
     */
    Map listPaginated(Map args) {
        Class domainClass = args.domainClass
        def params = args.params
        Map<String, Object> equalFields = args.equalFields ?: [:]
        List<String> searchableFields = args.searchableFields ?: []
        String defaultSort = args.defaultSort ?: 'id'
        String defaultOrder = args.defaultOrder ?: 'desc'
        
        int totalCount = domainClass.count()
        
        // Early return if no records
        if (totalCount == 0) {
            return buildEmptyPaginationResult(args, params, defaultSort, defaultOrder)
        }

        int max = params.int('max') ?: 10
        int offset = params.int('offset') ?: 0
        String sort = params.sort ?: defaultSort
        String sortOrder = params.order ?: defaultOrder

        // Extract search query
        String query = extractStringParam(params.query)

        try {
            def criteria = domainClass.createCriteria()
            def results = criteria.list(max: max, offset: offset) {
                
                // Apply equal field filters
                if (equalFields) {
                    equalFields.each { key, value ->
                        if (value != null) {
                            applyEqualField(delegate, key.tokenize('.'), value)
                        }
                    }
                }

                // Apply search across searchable fields
                if (query && searchableFields) {
                    or {
                        searchableFields.each { field ->
                            if (field != null) {
                                applySearchField(delegate, field.tokenize('.'), query)
                            }
                        }
                    }
                }

                order(sort, sortOrder)
            }

            return buildPaginationResult(results, args, params, max, offset, sort, sortOrder, totalCount)

        } catch (Exception e) {
            log.error("Error in paginated listing for ${domainClass.simpleName}: ${e.message}")
            return buildEmptyPaginationResult(args, params, defaultSort, defaultOrder)
        }
    }

    // ====================================================================
    // PRIVATE HELPER METHODS
    // ====================================================================

    /**
     * Extract string parameter handling arrays
     */
    private String extractStringParam(param) {
        if (param == null) return null
        return param instanceof String[] ? param[0]?.trim() : param?.trim()
    }

    /**
     * Build empty pagination result
     */
    private Map buildEmptyPaginationResult(Map args, params, String defaultSort, String defaultOrder) {
        return [
            results: [],
            total: 0,
            currentPage: 1,
            totalPages: 0,
            max: params.int('max') ?: 10,
            offset: 0,
            sort: params.sort ?: defaultSort,
            order: params.order ?: defaultOrder,
            params: params
        ]
    }

    /**
     * Build complete pagination result
     */
    private Map buildPaginationResult(results, Map args, params, int max, int offset, String sort, String sortOrder, int totalCount) {
        int totalPages = Math.ceil(results.totalCount / max as double) as int ?: 1
        int currentPage = Math.min(((offset / max) + 1) as int, totalPages)

        return [
            results: results,
            total: results.totalCount,
            currentPage: currentPage,
            totalPages: totalPages,
            max: max,
            offset: offset,
            sort: sort,
            order: sortOrder,
            params: params
        ]
    }

    /**
     * Apply nested equality filters for dotted field names
     */
    private void applyEqualField(builder, List<String> fieldParts, value) {
        if (fieldParts.size() == 1) {
            if (value instanceof List) {
                builder.'in'(fieldParts[0], value)
            } else {
                builder.eq(fieldParts[0], value)
            }
        } else {
            builder."${fieldParts[0]}" {
                applyEqualField(delegate, fieldParts.tail(), value)
            }
        }
    }

    /**
     * Apply nested search filters for dotted field names
     */
    private void applySearchField(builder, List<String> fieldParts, query) {
        if (fieldParts.size() == 1) {
            builder.ilike(fieldParts[0], "%${query}%")
        } else {
            builder."${fieldParts[0]}" {
                applySearchField(delegate, fieldParts.tail(), query)
            }
        }
    }

    /**
     * Bind properties from params to instance, excluding system fields
     */
    private void updateProperties(instance, Map params) {
        def excludedProperties = ['id', 'version', 'dateCreated', 'lastUpdated']
        def bindingSource = new SimpleMapDataBindingSource(params)
        grailsWebDataBinder.bind(instance, bindingSource, null, null, excludedProperties)
    }
}