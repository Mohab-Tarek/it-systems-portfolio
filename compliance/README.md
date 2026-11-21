# FRA and PDPL compliance for a small non-bank lender

How I put three Egyptian rules into practice at a consumer finance company, and how another FRA-licensed firm of around 50 staff can do the same:

- FRA Board Resolution 227 of 2025 (cybersecurity and technology infrastructure)
- FRA Decree 139 of 2023 (minimum technology infrastructure, information systems and security measures)
- the Personal Data Protection Law (Law 151 of 2020) and its Executive Regulations, Ministerial Decree 816 of 2025

This is an engineer's implementation guide, not legal advice. The summaries below come from the FRA's own announcement and the law firm briefings listed under [Sources](#sources). Check each obligation against the Arabic text in the Official Gazette, and with your lawyer, before you rely on it.

## What each rule asks for

### FRA Board Resolution 227 of 2025

Issued in October 2025 for firms licensed in non-bank financial activities. The FRA treats compliance as a condition for keeping the operating licence.

- Bring technology infrastructure, information systems and security measures up to the standards in Decree 139 of 2023.
- Write an information security policy manual, have the Board approve it, and send it to the FRA straight after approval.
- Set up IT governance, IT risk management and cybersecurity frameworks, also approved by the Board and sent to the FRA.
- Run periodic penetration tests. The contract with the testing firm must commit it to notify the FRA of the results.
- Prepare an annual information security report and submit it to the FRA.
- Hold a cyber insurance policy from an insurer licensed in Egypt and renew it every year. The FRA stresses this for firms that work through digital platforms or apps.
- Grace periods for firms other than insurers: six months from the effective date for technology infrastructure, twelve months for everything else.

### FRA Decree 139 of 2023

Issued in July 2023 under the FinTech Law (Law 5 of 2022). Resolution 227 uses it as the benchmark.

- Sets the technology infrastructure and information systems a firm must have, including database, application and web servers, and the protection and security measures around them.
- Customer databases stay inside Egypt.
- The FRA must be told promptly if the head office or the data centre moves.

### PDPL and its Executive Regulations (Decree 816 of 2025)

The Executive Regulations were issued on 1 November 2025 and gave firms one year to comply. The law excludes entities supervised by the Central Bank of Egypt, but FRA-licensed firms are in scope.

- Controllers and processors need a licence or permit from the Personal Data Protection Centre (PDPC).
- Appoint a Data Protection Officer (DPO) registered with the PDPC.
- Report a personal data breach to the PDPC within 72 hours of becoming aware of it, or immediately where sensitive data or national security is involved. Tell the affected people within three working days of notifying the PDPC.
- Get a separate licence or permit before transferring personal data outside Egypt.
- Give sensitive data extra protection. The law counts financial data as sensitive, so most of a lender's customer records fall in this group.

## Applying it in a company of around 50 staff

A small lender cannot staff a security department. The work rests on a few people and on tools the company already pays for, so the aim is a short manual that matches what you run and evidence that builds up as a side effect of normal IT work.

### Who owns what

| Role | Who, in a small firm | Owns |
| --- | --- | --- |
| Board, or its Risk and Audit Committee | Directors | Approves the manual and frameworks, reviews the annual report |
| IT lead | Systems engineer or IT manager | Infrastructure, controls, evidence, the penetration test project |
| Information security lead | In-house, or a part-time external consultant | Policies, risk register, test scope, the annual report draft |
| Data Protection Officer | Often the Compliance Officer, registered with the PDPC | PDPC licence, record of processing, breach notices |
| Compliance Officer | Compliance | Submissions to the FRA |
| Outside parties | Hosting provider, penetration test firm, cyber insurer | Hosting in Egypt, independent testing, cover |

### Step by step

1. **Gap assessment (first month).** List every system, the personal data it holds and where it is hosted. Compare each one with the obligations above and log every gap as a Jira ticket with an owner and a due date. That Jira project becomes the risk register and the evidence trail.
2. **Hosting and infrastructure (inside the six-month window).** Keep the core lending application and its database with a hosting provider in Egypt, and record where every system lives. Put a firewall in front of all traffic, MFA on email and remote access, and endpoint protection on every device. Add one rule to change management: any change to where data is hosted opens a task to notify the FRA.
3. **Policy manual and frameworks.** Use ISO/IEC 27001 Annex A as the checklist for headings and write only what you actually do. For a firm this size the manual usually covers acceptable use, access control and MFA, passwords, backup and recovery, change management, incident response, suppliers, data classification and retention, remote work, and physical security including CCTV. Add the three frameworks (IT governance, IT risk, cybersecurity), get Board approval and send everything to the FRA.
4. **Penetration test.** Scope the internet-facing perimeter, the core application, Microsoft 365 and remote access. Put the FRA notification clause in the contract. Track each finding in Jira until it is fixed and retested.
5. **Cyber insurance.** Insurers ask for proof of MFA, endpoint protection, backups and patching. The tickets from steps 2 to 4 answer most of the questionnaire.
6. **PDPL.** Apply for the PDPC licence or permit and register the DPO. Build the record of processing from the gap assessment. Check every cloud service that may hold personal data outside Egypt (email, file storage, ticketing, endpoint consoles): either apply for a transfer licence or keep personal data out of that service. A rule such as "no customer data in Jira tickets" removes one transfer. Adopt the [breach playbook](pdpl-breach-playbook.md) and rehearse it once.
7. **Annual report.** Pull the year's evidence into the information security report: test results and fixes, incidents, access reviews, policy changes and the state of the risk register.

### Evidence calendar

| When | Task | Evidence |
| --- | --- | --- |
| Monthly | Patch servers and endpoints | Jira change tickets |
| Monthly | Review failed logons and idle accounts with the [scripts](../scripts) | Script output attached to a ticket |
| Quarterly | Access review with each department head | Signed review list |
| Quarterly | Risk register review | Updated Jira board |
| Yearly | Penetration test and retest | Report, fix tickets, the tester's notice to the FRA |
| Yearly | Information security report | Report and FRA submission record |
| Yearly | Cyber insurance renewal | Policy schedule |
| Yearly | Board review of the manual and frameworks | Board minutes |
| Yearly | Breach playbook rehearsal | Exercise notes |

### How a small stack covers the controls

| Control | Tool we used |
| --- | --- |
| Perimeter firewall | F5 firewall as a service |
| Remote access | FortiClient VPN |
| Endpoint protection and device control | Sophos Central |
| Identity, password and lockout policy, screen lock | Windows Server AD and Group Policy ([lab script](../lab/build-ad-lab.ps1)) |
| Email, files and MFA | Microsoft 365 and OneDrive |
| Hosting in Egypt | Raya Cloud: core application, Oracle database, middleware |
| Risk register, evidence, incidents | Jira |
| Physical security | Hikvision CCTV |

## Sources

- [FRA: Resolution 227 of 2025 announcement, 23 October 2025](https://fra.gov.eg/en/?p=18845985)
- [Clyde & Co: FRA decrees under the FinTech Law, July 2023](https://www.clydeco.com/en/insights/2023/07/egypt-financial-regulatory-authority)
- [Al Tamimi: FinTech executive decisions issued, July 2023](https://www.tamimi.com/news/finally-the-fintech-law-has-entered-into-force-by-the-issuance-of-the-long-awaited-fintech-executive-decisions)
- [CMS: PDPL Executive Regulations issued, January 2026](https://cms.law/en/are/legal-updates/egypt-s-pdpl-executive-regulations-issued-one-year-compliance-countdown-begins)
- [Al Tamimi: Egypt issues PDPL Executive Regulations](https://www.tamimi.com/news/from-policy-to-practice-egypt-issues-executive-regulations-of-the-personal-data-protection-law)
- [Chambers: a first look at the PDPL Executive Regulations](https://chambers.com/articles/a-first-look-at-egypt-s-personal-data-protection-executive-regulations)
