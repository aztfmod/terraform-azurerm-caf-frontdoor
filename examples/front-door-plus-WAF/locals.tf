locals {
    location = "global"
    prefix = "test"
    resource_groups = {
        test = { 
            name     = "-caf-afd"
            location = "uksouth" 
        },
    }
    tags = {
        environment     = "DEV"
        owner           = "CAF"
    }
}