package awana

import grails.util.Environment
import grails.gorm.transactions.Transactional

class BootStrap {

    def init = { servletContext ->
        if (Environment.current == Environment.DEVELOPMENT) {
            createTestUsersAndRoles()
        }
    }
    
    def destroy = {
    }
    
    @Transactional
    private void createTestUsersAndRoles() {
        // Create roles
        def adminRole = Role.findByAuthority('ROLE_ADMIN')
        if (!adminRole) {
            adminRole = new Role(authority: 'ROLE_ADMIN').save(flush: true)
        }
        
        def userRole = Role.findByAuthority('ROLE_USER')
        if (!userRole) {
            userRole = new Role(authority: 'ROLE_USER').save(flush: true)
        }
        
        // Create admin user
        if (!User.findByUsername('admin')) {
            def admin = new User(
                username: 'admin',
                password: 'admin123',
                enabled: true
            ).save(flush: true)
            
            UserRole.create(admin, adminRole, true)
            UserRole.create(admin, userRole, true)
            
            log.info("Created admin user: admin/admin123")
        }
        
        // Create test user
        if (!User.findByUsername('user')) {
            def user = new User(
                username: 'user', 
                password: 'user123',
                enabled: true
            ).save(flush: true)
            
            UserRole.create(user, userRole, true)
            
            log.info("Created test user: user/user123")
        }
    }
}