# IP Address & Network Plan

> **Note:** This is the **target design**. Phase 1 was built on a single flat subnet (`10.0.10.0/24`) with temporary addresses; the VLAN-segmented scheme below is implemented in Phase 3, at which point servers are re-IP'd and clients re-lease onto their VLAN subnets. See `phases/01-foundation.md` for the current as-built state.

## Subnet allocation

| VLAN | Name | Subnet | Gateway | Purpose |
|---|---|---|---|---|
| 10 (native) | Management | 10.0.10.0/24 | 10.0.10.1 | pfSense management, infrastructure access |
| 20 | Servers | 10.0.20.0/24 | 10.0.20.1 | Domain controller, application servers |
| 30 | Workstations | 10.0.30.0/24 | 10.0.30.1 | End-user clients, DHCP-assigned |
| 40 | DMZ | 10.0.40.0/24 | 10.0.40.1 | Internet-facing services (mail, monitoring) |
| 50 | VPN | 10.0.50.0/24 | 10.0.50.1 | Remote access clients |
| 60 | Voice | 10.0.60.0/24 | 10.0.60.1 | VOIP, future expansion |

## Static IP assignments

| Host | VLAN | IP | OS | Role |
|---|---|---|---|---|
| pfSense (`PFSENSE-FW01`) | — | LAN: 10.0.10.1 / WAN: DHCP from vmnet8 | pfSense CE | Firewall, router, DHCP relay |
| `WS22-DC01` | 20 | 10.0.20.10 | Windows Server 2022 | Domain controller, AD, DNS, DHCP |
| `WIN-CLIENT01` | 30 | DHCP (10.0.30.50–200) | Windows 11 Pro | Domain-joined workstation / admin workstation |
| `WIN-CLIENT02` *(optional)* | 30 | DHCP (10.0.30.50–200) | Windows 11 Pro | Domain-joined workstation (multi-machine GPO testing) |
| `ubuntu-srv01` | 40 | 10.0.40.10 | Ubuntu Server 24.04 | SMTP relay, monitoring, syslog |

## DHCP scope (VLAN 30 / Workstations)

- Pool: 10.0.30.50 – 10.0.30.200
- Reservations: (none initially; document any added later)
- Options: gateway 10.0.30.1, DNS 10.0.20.10, search domain `lab.internal`
- Lease time: 8 hours

## DNS

- Primary internal DNS: `WS22-DC01` (10.0.20.10) — authoritative for `lab.internal`
- Secondary / external: pfSense resolver (10.0.10.1) — forwards to 1.1.1.1 and 9.9.9.9
- Clients: primary 10.0.20.10, secondary 10.0.10.1

## Firewall policy (high level, refined per phase)

| Source | Destination | Allowed | Logged |
|---|---|---|---|
| VLAN 30 (Workstations) | VLAN 20 (Servers) | DNS, LDAP, LDAPS, SMB, RDP, Kerberos | Y |
| VLAN 30 (Workstations) | VLAN 40 (DMZ) | SMTP, HTTPS, monitoring | Y |
| VLAN 40 (DMZ) | VLAN 20 (Servers) | SMTP only | Y |
| Any | Internet | Allow with NAT | Y |
| Internet | Any | Deny (default) | Y (drops) |

---

*Last updated: 2026-05-26. This document evolves as the lab is built — earlier entries may not reflect current state. See `phases/` for the per-phase changelog.*
