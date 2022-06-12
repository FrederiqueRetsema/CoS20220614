# Conclusion on Stage - AWS Step Functions
In deze repo vindt je de presentatie, inclusief alle voorbeelden voor de presentatie op
Conclusion on Stage op 14 juni. Alle voorbeelden zijn afkomstig uit de AWS documentatie, 
zie deze URL:
https://docs.aws.amazon.com/step-functions/latest/dg/tutorials.html 
onder "Tutorials" en onder "Sample projects for Step Functions".

Ik heb de code zoals die door AWS gepresenteerd wordt aangepast zodat alle
resources beginnen met COS01 (t/m COS10), dit maakte het makkelijker om tijdens
de presentatie de juiste voorbeelden terug te vinden.

Uitzondering is COS08_Call_From_EventBridge.yaml: deze heb ik zelf geschreven omdat 
ik geen voorbeeld binnen de AWS documentatie zag.

## Parameters voor Step Functions
Bij de volgende Step Functions zijn parameters nodig om e.e.a. goed te laten
werken:

### COS01 Create a Step Functions State Machine That Uses Lambda Functions
```
{
    "who": "Conclusion Publiek"
}
```

### COS03 Using a Map State to Call Lambda Multiple Times
```
[
    {
        "who": "Jan"
    },
    {
        "who": "Piet"
    },
    {
        "who": "Klaas"
    },
]
```

### COS07 Poll For Job Status

```
{
  "jobName": "my-job",
  "jobDefinition": "arn:aws:batch:eu-west-1:040909972200:job-definition/SampleJobDefinition-d8c378adebad8af:1",
  "jobQueue": "arn:aws:batch:eu-west-1:040909972200:job-queue/SampleJobQueue-eDL1vEjpIWqmdZaL",
  "wait_time": 15
}
```

(N.B: Je kunt deze input knippen/plakken uit de "Outputs" van de CloudFormation template COS07 - ik heb de default van 60 seconden uit het AWS voorbeeld vervangen door 15 seconden om de presentatie iets levendiger te maken)

### COS08 Call From Eventbridge
Deze StepFunction wordt automatisch gestart als een VM de status "RUNNING" krijgt. Start dus een
nieuwe virtual machine op om deze StepFunction te starten.

### COS09 Call From API Gateway
Voorbeeld curl commando:
```
curl -X POST -d '{"input": "{\"who\":\"Conclusion Publiek\"}", "name": "MyExecution", "stateMachineArn": "arn:aws:states:eu-west-1:040909972200:stateMachine:COS09LambdaStatemachine-qs1yYEwQekP5"}' https://l1zggju033.execute-api.eu-west-1.amazonaws.com/CoS/execution
```

(N.B: Je kunt deze input knippen/plakken uit de "Outputs" van de CloudFormation template COS09. Ik heb in de demo zelf de CloudShell binnen AWS gebruikt om deze curl uit te voeren. Wijzig
de naam "MyExecution" als je deze curl vaker uitvoert).

### COS10 Deploying an Example Human Approval Project
Je kunt de LoadStacks.ps1 gebruiken om de templates uit te rollen (zie volgende paragraaf). Wijzig
het e-mail adres na het uitvoeren van de stack in een e-mail adres waar je zelf toegang toe hebt. Of
wijzig de default in Code > CloudFormation > 10_Deploying_an_Example_Human_Approval_Project voordat
je de stack uitrolt.

## Zelf de stacks in je eigen account inladen

### Laden
Ik gebruik twee scripts om dit te doen: Code > LoadStacks.ps1 en Code > DeleteStacks.ps1. Beide
hebben de -profile parameter (als je deze weglaat gebruikt hij het "default" profile). Gebruik 
voor het laden van de stacks evt. het LoadStacks.ps1 script:

Als je gebruik wilt maken van de templates zonder die te wijzigen (je gebruikt dan de templates
uit mijn bucket cos20220614, read-only):
```
.\LoadStacks -profile eigenprofiel
```

Je kunt er ook voor kiezen om alle templates in een eigen bucket te zetten, gebruik dan:
```
.\LoadStacks -s3bucket eigenbucketnaam -uploadtos3 -profile eigenprofiel
```

Geef eventueel een andere regio mee (-region eu-central-1) als je de presentatie niet in eu-west-1 (Ierland) wilt uitrollen.

### Deleten
Je kunt de stacks uit je account verwijderen met het script 
```
.\DeleteStacks -profile eigenprofiel
```

Ook deze kent -region als parameter voor het geval je in een andere regio wilt uitrollen.

## Zelf deze presentatie geven
Als je deze presentatie zelf wilt geven dan kan dat, alle slides en templates zijn daarvoor te
gebruiken. Als de Wifi van de locatie goed werkt zal ik slides 5-14 (en 16) niet tonen.
Aanvulling: in de demo laat ik nog wel snel zien hoe het handmatig aanmaken van een Step Function
via de wizard werkt.

Hieronder nog wat aantekeningen zoals ik die zelf gebruikt heb in de voorbereiding:

```
Voorbereiding (paar dagen van te voren)
---------------------------------------
* Uitrollen alle CloudFormation stacks, SNS approval in mailbox
* Toevoegen user cos20220614 met wachtwoord DitIsNietHetEchteWachtwoord20220614!

  Read Only 
  + alle rechten Lambda 
  + alle rechten EC2 Instance
  + alle rechten Step Functions
  + alle rechten CloudFormation
  + alle rechten EventBridge
* Specifiek Chrome profile:
  - AWS Documentatie
  - Ingelogd in AWS, hoofscherm
  - Ingelogd in AWS CloudFormation
  - Ingelogd in EC2
  - Ingelogd CloudShell
  - Ingelogd in Outlook test mailbox cos20220614@outlook.com
  - Presentatie, pagina 15
* Stoppen en starten alle stacks

Voorafgaand aan presentatie
===========================
Check WiFi
Open presentatie
Open Chrome
	Delete alle mail uit de mailbox
    Open presentatie in Chrome, op pagina met overview COS10
Open Notepad++
Stop alle EC2's
```
