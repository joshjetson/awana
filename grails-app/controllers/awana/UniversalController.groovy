package awana

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.util.GrailsNameUtils

@Secured(['ROLE_USER', 'ROLE_ADMIN'])
class UniversalController {

    UniversalDataService universalDataService

    /**
     * GET /
     * Index page for testing login
     */
    def index() {
        // Just render the main index view 
        [:]
    }

    /**
     * GET /universal/{domainName}
     * List all instances of a domain class with optional pagination and search
     */
    def list() {
        String domainName = params.domainName
        Class domainClass = getDomainClass(domainName)
        
        if (!domainClass) {
            render status: 404, text: "Domain class '${domainName}' not found"
            return
        }

        try {
            if (params.paginated == 'true') {
                // Advanced paginated listing
                def searchableFields = getSearchableFields(domainClass)
                def result = universalDataService.listPaginated([
                    domainClass: domainClass,
                    params: params,
                    searchableFields: searchableFields,
                    defaultSort: 'id',
                    defaultOrder: 'desc'
                ])
                
                if (isHtmxRequest()) {
                    // Render template fragment for HTMX
                    render(template: 'listTable', model: [result: result, domainName: domainName])
                    return
                } else if (isJsonRequest()) {
                    render result as JSON
                } else {
                    [result: result, domainName: domainName]
                }
            } else {
                // Simple listing
                def instances = universalDataService.list(domainClass)
                
                if (isHtmxRequest()) {
                    // Render template fragment for HTMX
                    render(template: 'listItems', model: [instances: instances, domainName: domainName])
                    return
                } else if (isJsonRequest()) {
                    render instances as JSON
                } else {
                    [instances: instances, domainName: domainName]
                }
            }
        } catch (Exception e) {
            log.error("Error listing ${domainName}: ${e.message}")
            render status: 500, text: "Error listing ${domainName}"
        }
    }

    /**
     * GET /universal/{domainName}/{id}
     * Show specific instance
     */
    def show() {
        String domainName = params.domainName
        Long id = params.long('id')
        Class domainClass = getDomainClass(domainName)
        
        if (!domainClass || !id) {
            render status: 404, text: "Domain class '${domainName}' not found or invalid ID"
            return
        }

        try {
            def instance = universalDataService.getById(domainClass, id)
            
            if (!instance) {
                render status: 404, text: "${domainName} with ID ${id} not found"
                return
            }

            if (isHtmxRequest()) {
                // Render template fragment for HTMX
                render(template: 'showDetail', model: [instance: instance, domainName: domainName])
                return
            } else if (isJsonRequest()) {
                render instance as JSON
            } else {
                [instance: instance, domainName: domainName]
            }
        } catch (Exception e) {
            log.error("Error showing ${domainName} ${id}: ${e.message}")
            render status: 500, text: "Error retrieving ${domainName}"
        }
    }

    /**
     * POST /universal/{domainName}
     * Create new instance
     */
    def save() {
        String domainName = params.domainName
        Class domainClass = getDomainClass(domainName)
        
        if (!domainClass) {
            render status: 404, text: "Domain class '${domainName}' not found"
            return
        }

        try {
            def instance = universalDataService.save(domainClass, params)
            
            if (instance) {
                if (isHtmxRequest()) {
                    // Render success template fragment for HTMX
                    render(template: 'createSuccess', model: [instance: instance, domainName: domainName])
                    return
                } else if (isJsonRequest()) {
                    render status: 201, contentType: 'application/json', text: (instance as JSON).toString()
                } else {
                    flash.success = "${domainName} created successfully"
                    redirect action: 'show', params: [domainName: domainName, id: instance.id]
                }
            } else {
                if (isHtmxRequest()) {
                    render status: 400, template: 'createError', model: [domainName: domainName, message: "Failed to create ${domainName}"]
                    return
                } else if (isJsonRequest()) {
                    render status: 400, text: "Failed to create ${domainName}"
                } else {
                    flash.error = "Failed to create ${domainName}"
                    redirect action: 'list', params: [domainName: domainName]
                }
            }
        } catch (Exception e) {
            log.error("Error creating ${domainName}: ${e.message}")
            render status: 500, text: "Error creating ${domainName}"
        }
    }

    /**
     * PUT /universal/{domainName}/{id}
     * Update existing instance
     */
    def update() {
        String domainName = params.domainName
        Long id = params.long('id')
        Class domainClass = getDomainClass(domainName)
        
        if (!domainClass || !id) {
            render status: 404, text: "Domain class '${domainName}' not found or invalid ID"
            return
        }

        try {
            def instance = universalDataService.update(domainClass, id, params)
            
            if (instance) {
                if (isHtmxRequest()) {
                    // Render updated template fragment for HTMX
                    render(template: 'updateSuccess', model: [instance: instance, domainName: domainName])
                    return
                } else if (isJsonRequest()) {
                    render instance as JSON
                } else {
                    flash.success = "${domainName} updated successfully"
                    redirect action: 'show', params: [domainName: domainName, id: id]
                }
            } else {
                if (isHtmxRequest()) {
                    render status: 400, template: 'updateError', model: [domainName: domainName, message: "Failed to update ${domainName}"]
                    return
                } else if (isJsonRequest()) {
                    render status: 400, text: "Failed to update ${domainName}"
                } else {
                    flash.error = "Failed to update ${domainName} or not found"
                    redirect action: 'list', params: [domainName: domainName]
                }
            }
        } catch (Exception e) {
            log.error("Error updating ${domainName} ${id}: ${e.message}")
            render status: 500, text: "Error updating ${domainName}"
        }
    }

    /**
     * DELETE /universal/{domainName}/{id}
     * Delete instance
     */
    def delete() {
        String domainName = params.domainName
        Long id = params.long('id')
        Class domainClass = getDomainClass(domainName)
        
        if (!domainClass || !id) {
            render status: 404, text: "Domain class '${domainName}' not found or invalid ID"
            return
        }

        try {
            boolean deleted = universalDataService.deleteById(domainClass, id)
            
            if (deleted) {
                if (isHtmxRequest()) {
                    // For HTMX deletes, typically remove the element from DOM or show success message
                    render status: 200, template: 'deleteSuccess', model: [domainName: domainName, id: id]
                    return
                } else if (isJsonRequest()) {
                    render status: 204, text: ''
                } else {
                    flash.success = "${domainName} deleted successfully"
                    redirect action: 'list', params: [domainName: domainName]
                }
            } else {
                if (isHtmxRequest()) {
                    render status: 404, template: 'deleteError', model: [domainName: domainName, message: "${domainName} not found"]
                    return
                } else if (isJsonRequest()) {
                    render status: 404, text: "${domainName} not found"
                } else {
                    flash.error = "${domainName} not found or could not be deleted"
                    redirect action: 'list', params: [domainName: domainName]
                }
            }
        } catch (Exception e) {
            log.error("Error deleting ${domainName} ${id}: ${e.message}")
            render status: 500, text: "Error deleting ${domainName}"
        }
    }

    /**
     * GET /universal/{domainName}/count
     * Get count of instances
     */
    def count() {
        String domainName = params.domainName
        Class domainClass = getDomainClass(domainName)
        
        if (!domainClass) {
            render status: 404, text: "Domain class '${domainName}' not found"
            return
        }

        try {
            def count = universalDataService.count(domainClass)
            render contentType: 'application/json', text: [count: count] as JSON
        } catch (Exception e) {
            log.error("Error counting ${domainName}: ${e.message}")
            render status: 500, text: "Error counting ${domainName}"
        }
    }

    // ====================================================================
    // PRIVATE HELPER METHODS
    // ====================================================================

    /**
     * Resolve domain class from string name
     */
    private Class getDomainClass(String domainName) {
        if (!domainName) return null
        
        try {
            // Try with the awana package first
            String className = "awana.${GrailsNameUtils.getClassName(domainName)}"
            return Class.forName(className)
        } catch (ClassNotFoundException e1) {
            try {
                // Try without package
                return Class.forName(GrailsNameUtils.getClassName(domainName))
            } catch (ClassNotFoundException e2) {
                log.warn("Domain class not found: ${domainName}")
                return null
            }
        }
    }

    /**
     * Get searchable fields for a domain class
     * This is a basic implementation - in real app you might want to configure this per domain
     */
    private List<String> getSearchableFields(Class domainClass) {
        def fields = []
        
        // Common searchable fields for most domains
        if (domainClass.declaredFields.find { it.name == 'name' }) {
            fields << 'name'
        }
        if (domainClass.declaredFields.find { it.name == 'username' }) {
            fields << 'username'
        }
        if (domainClass.declaredFields.find { it.name == 'email' }) {
            fields << 'email'
        }
        if (domainClass.declaredFields.find { it.name == 'title' }) {
            fields << 'title'
        }
        if (domainClass.declaredFields.find { it.name == 'description' }) {
            fields << 'description'
        }
        
        return fields
    }

    /**
     * Check if this is an HTMX request
     */
    private boolean isHtmxRequest() {
        return request.getHeader('HX-Request') == 'true'
    }

    /**
     * Check if this is a JSON API request (for REST endpoints)
     */
    private boolean isJsonRequest() {
        return params.format == 'json' || 
               request.getHeader('Accept')?.contains('application/json')
    }
}