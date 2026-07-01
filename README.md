# Home Lab: Enterprise Network in VMs

A virtualized small-business IT environment running on a single Linux host via VMware Workstation Pro. Demonstrates network design, Windows Server administration, Active Directory, Microsoft 365 hybrid identity, monitoring, email infrastructure, and documentation discipline.

## Status

🚧 **In progress.** Building this in phases as part of the CompTIA Network+ exam preparation and an IT skills refresh. See `/phases/` for week-by-week documentation as the lab comes online.

**Phase 4 (SMTP relay): complete.**

## Architecture (target state)

- pfSense firewall/router with multi-VLAN segmentation
- Windows Server 2022 domain controller for the `lab.internal` domain (AD DS, DNS, DHCP, GPO)
- Windows 11 Pro domain-joined client workstation
- Ubuntu Server 24.04 running SMTP relay, monitoring (LibreNMS), and syslog aggregation
- Microsoft 365 Developer tenant with hybrid identity via Entra Connect
- VOIP via FreePBX

## Repo layout

- `/docs/` — architecture, IP plan, network diagrams, design rationale
- `/phases/` — week-by-week build documentation
- `/scripts/` — any scripts created alongside the phases

## What this demonstrates

Network design and segmentation • Active Directory administration • Windows Server • Linux server administration • Identity and access management • Email infrastructure • Monitoring and observability • Microsoft 365 administration • Documentation discipline

## Why this exists

Returning to IT after a career gap. This lab is both Net+ exam preparation and a public artifact showing current systems and network administration skills.

---

*Last updated: 06-30-2026*
