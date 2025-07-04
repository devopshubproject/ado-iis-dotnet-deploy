
## Challenge #1 - Deploy a Web Application on IIS
---
## 1. Deploy a Simple .NET Web Application using IIS

### Deployment Approach
- Provision a Windows Server 2019 or 2022 VM in Azure.
- Install IIS using PowerShell:

  ```powershell
  Install-WindowsFeature -Name Web-Server -IncludeManagementTools
  ```

- Deploy your .NET application to `C:\inetpub\wwwroot` or configure a dedicated folder/site.
- Set up IIS Application Pool, Bindings, MIME types, Authentication, and SSL.
- Open necessary ports (80/443) via Network Security Groups (NSG).
- Assign a DNS name via Azure Public IP (or custom domain).
- Enable HTTPS using a certificate from Azure Key Vault or self-signed cert for dev/testing.

---

## 2. Secure the Deployment

### IIS Hardening Best Practices
- Remove unused modules, handlers.
- Enable request filtering.
- Disable directory browsing.
- Limit HTTP methods (e.g., only GET, POST).
- Configure custom error pages.
- Apply SSL and redirect HTTP to HTTPS.
- Set strict file/folder permissions.
- Run app pool with least privileges.
- Regularly apply Windows Updates.
- Use Windows Defender or Endpoint Protection.

---

## 3. Load Balancing and High Availability

### Azure Load Balancer (Layer 4)
- Use Standard Load Balancer for multiple IIS VMs.
- Backend pool with VMs, health probe for IIS (e.g., `/healthcheck`).

### Azure Application Gateway (Layer 7)
- Web Application Firewall (WAF) integration.
- TLS termination.
- URL-based routing.
- Rewrites and redirection support.

### Azure Traffic Manager (Optional)
- Geo-distribution and DNS-based failover across regions.

---

## 4. Network Security and Access Control

### Azure Firewall
- Controls all egress traffic.
- Deny by default, allow specific domains/IPs.
- Combine with NSGs to filter east-west and north-south traffic.

### Azure Bastion
- Secure RDP/SSH access from browser.
- No public IP needed on VMs.
- Integrates with Azure AD login.

---

## 5. Identity and Secret Management

### Azure Managed Identity
- Assign System-assigned or User-assigned Managed Identity to VM.
- Use identity to access:
  - Azure Key Vault for secrets or certs.
  - Azure Storage for files.
  - Azure SQL for DB access.
- No credentials in code/config.

### Key Vault Access Example

```json
"accessPolicies": [
  {
    "tenantId": "<tenant-id>",
    "objectId": "<managed-identity-object-id>",
    "permissions": {
      "secrets": [ "get", "list" ]
    }
  }
]
```

---

## 6. Governance and Role Management

### Azure AD PIM (Privileged Identity Management)
- Enforce Just-in-Time (JIT) access to sensitive roles.
- Enable approvals, MFA, and justification.
- Track activations and audit logs.

#### Example Role Assignments:

| Role                  | Assignment Type | Approval | Duration |
|-----------------------|------------------|----------|----------|
| Key Vault Contributor | Eligible         | Yes      | 4 hours  |
| VM Contributor        | Eligible         | Yes      | 2 hours  |

---

## 7. Architecture Diagram (Text-based)

```
   ┌───────────────┐          ┌────────────────────┐
   │ Azure Bastion │────────▶│ Windows Server (IIS)│◀───────┐
   └──────┬────────┘          └──────────┬──────────┘       │
          │                              │                  │
          │    RDP via Bastion           │    Hosts .NET    │
          ▼                              ▼     Web App      │
  ┌────────────────┐           ┌────────────────────┐       │
  │ Admin/Dev User │           │     Second VM       │◀─────┘
  └────────────────┘           │ (Optional for HA)   │
                               └──────────┬──────────┘
                                          │
                       ┌──────────────────┴───────────────────┐
                       │        Azure Load Balancer (L4)      │
                       └──────────┬──────────────┬────────────┘
                                  ▼              ▼
                          ┌─────────────┐  ┌─────────────┐
                          │ IIS VM #1   │  │ IIS VM #2   │
                          └─────────────┘  └─────────────┘
                                  │              │
                                  ▼              ▼
                         ┌────────────────────────────┐
                         │ Azure Application Gateway   │
                         │ (WAF, TLS termination, L7)  │
                         └────────────┬───────────────┘
                                      ▼
                           ┌────────────────────┐
                           │   Azure Firewall   │
                           │  (Egress control)  │
                           └──────────┬─────────┘
                                      ▼
                            Internet / External Services
```

---

## 8. Deliverables Summary

| Item                        | Description                                              |
|-----------------------------|----------------------------------------------------------|
| PowerShell Script           | Install IIS, deploy app, configure bindings              |
| Architecture Diagram        | Provided above and as image (optional)                  |
| Security Configuration      | IIS + Azure Firewall + NSGs + Managed Identity + PIM    |
| Deployment Documentation    | This document                                            |
| Optional Enhancements       | App Gateway WAF, Bastion, CI/CD, Monitoring, Alerting   |

---