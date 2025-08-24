package awana

class UrlMappings {
    static mappings = {
        // Universal API routes for dynamic domain operations
        "/api/universal/$domainName"(controller: "universal", action: "list", method: "GET")
        "/api/universal/$domainName/count"(controller: "universal", action: "count", method: "GET")
        "/api/universal/$domainName"(controller: "universal", action: "save", method: "POST")
        "/api/universal/$domainName/$id"(controller: "universal", action: "show", method: "GET")
        "/api/universal/$domainName/$id"(controller: "universal", action: "update", method: "PUT")
        "/api/universal/$domainName/$id"(controller: "universal", action: "delete", method: "DELETE")
        
        // Standard Grails mappings
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/"(view:"/index")
        "500"(view:'/error')
        "404"(view:'/notFound')
    }
}
