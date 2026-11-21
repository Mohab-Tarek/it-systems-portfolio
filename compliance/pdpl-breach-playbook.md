# Personal data breach playbook

For an FRA-licensed lender under the Personal Data Protection Law (Law 151 of 2020) and its Executive Regulations (Ministerial Decree 816 of 2025). Replace the roles with names and phone numbers, keep a printed copy away from the systems it protects, and have your lawyer check it against the Arabic text.

## The clock

- It starts when the company becomes aware of the breach, not when the breach happened.
- PDPC: within 72 hours, or immediately where sensitive data is involved. A lender's customer records include financial data, which the law treats as sensitive, so plan to report as soon as step 3 gives you the basic facts.
- Affected people: within three working days of the PDPC notice.
- There is no size threshold. A small breach is still reported.

## Roles

| Role | Usually | Does |
| --- | --- | --- |
| Incident lead | IT lead | Runs the response and keeps the timeline |
| Data Protection Officer | Registered DPO | Sends the notices to the PDPC and to affected people |
| Security lead | Information security lead | Investigation and evidence |
| Management | CEO or a delegate | Approves customer messages and any public statement |
| Compliance | Compliance Officer | Decides whether the FRA should also be told |

## Steps

1. **Report and log (minute 0).** Anyone who suspects a breach tells IT at once. IT opens a Jira ticket of type "Personal data incident" and records the time of awareness. That time starts the clock.
2. **Contain (first hours).** Depending on what happened:
    - isolate the device in Sophos Central
    - disable the account in AD and Microsoft 365 and end its sessions
    - block the source address on the firewall
    - remove external sharing links in OneDrive
    - ask the hosting provider to preserve logs and take snapshots before anything is rebuilt
3. **Assess (aim for the first 24 hours).** Establish which systems and data are involved, roughly how many people and records, whether sensitive data such as financial records or national ID numbers is included, whether the data left the company or was only exposed, and the likely consequences for the people affected.
4. **Notify the PDPC (within 72 hours, immediately for sensitive data).** The DPO sends:
    - what happened and when it was discovered
    - the categories of data and the approximate number of people and records
    - the likely consequences
    - the measures taken and planned
    - the DPO's contact details

    If facts are still missing, send what is known and follow up.
5. **Tell affected people (within three working days of the PDPC notice).** Use plain language: what happened, which of their data, what the company is doing, what they should do, and who to contact. For a lender, warn them that the company will never call to ask for an OTP code or a card PIN.
6. **Record.** Enter the breach, every notice and every decision in the breach register, kept in a secure electronic form.
7. **Recover and review (suggested: within two weeks).** Fix the root cause, check the fix holds, update the risk register and the relevant policy, and close the Jira ticket with a short lessons-learned note.

## Customer notice (example wording)

> On [date] we found that [what happened]. It involved your [types of data]. We have [action taken] and reported the incident to the Personal Data Protection Centre. We will never call or message you to ask for an OTP code, password or card PIN. If you have questions, contact our Data Protection Officer at [email or phone].

## Yearly rehearsal

Run a one-hour tabletop exercise. Example scenario: a collections agent's laptop holding an exported customer list is stolen from a car. Walk through steps 1 to 7 against the clock, note where people hesitated or lacked access, and fix those gaps.
