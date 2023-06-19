# Apps Require App Gateway Front End

Custom policy to ensure that all HTTPS App Service Apps are behind an Application Gateway
Policy checks in the backend pool of Application Gateway and ensures each App is part of the backend pool, if not the policy effect(auditIfNotExists) triggers.
