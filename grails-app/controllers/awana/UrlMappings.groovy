package awana

class UrlMappings {
    static mappings = {
        // API routes for dynamic domain operations
        "/api/universal/$domainName"(controller: "universal", action: "list", method: "GET")
        "/api/universal/$domainName/count"(controller: "universal", action: "count", method: "GET")
        "/api/universal/$domainName"(controller: "universal", action: "save", method: "POST")
        "/api/universal/$domainName/$id"(controller: "universal", action: "show", method: "GET")
        "/api/universal/$domainName/$id"(controller: "universal", action: "update", method: "PUT")
        "/api/universal/$domainName/$id"(controller: "universal", action: "delete", method: "DELETE")
        
        // Login routes (keep explicit since they use different controller)
        "/login"(controller: "login", action: "index")
        "/login/auth"(controller: "login", action: "auth")
        // Spring Security will handle /login/authenticate and /logout automatically
        
        // Dynamic view rendering - the core SPA endpoint  
        "/renderView"(controller: "universal", action: "renderView")
        
        // Generic controller/action routing for other controllers
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/"(controller: "universal", action: "index")
        "/$action/$id?"(controller: "universal")
        "500"(view:'/error')
        "404"(view:'/notFound')
    }
}
