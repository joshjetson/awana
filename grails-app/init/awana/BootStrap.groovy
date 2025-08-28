package awana

import grails.util.Environment
import grails.gorm.transactions.Transactional

class BootStrap {

    BootstrapService bootstrapService

    def init = { servletContext ->
        environments {
            development {

            }
            production {

            }
        }
        
        bootstrapService.createRoles()
        bootstrapService.createDevelopmentUsers()
        
        // Only create Awana data if no clubs exist yet
        if (Club.count() == 0) {
            bootstrapService.createAwanaData()
            log.info("Awana bootstrap data initialization completed")
        } else {
            log.info("Awana data already exists, skipping bootstrap creation")
        }
    }
    
    def destroy = {
    }
    
}