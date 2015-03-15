# FHIR API Reference

## Accessing the API from our web app

We can make calls to the FHIR API from our ruby code using the following
structure (after adding the httparty gem via `gem 'httparty'` in the gem file):

```ruby
require 'httparty'
response = HTTParty.get('http://fhirtest.uhn.ca/baseDstu1/Patient/4389?_format=json')
```

Then the JSON can be parsed in ruby by the controllers to be injected into the
appropriate views using the following structure (after the json gem has been
installed - `gem install json`):

```ruby
require 'json'
rubyFhirDataHash = JSON.parse(response.body)
```

'rubyFhirDataHash' would then contain a dictionary where the keys are the
labels from the API server's JSON response.

```ruby
lastName = rubyFhirDataHash["name"][0]["family"]
```

## Sample GT FHIR API Calls

Note that the machine making calls to the GT FHIR API must be connected to the
GT network, or it will not receive a response (instructions for VPN-ing into
the GT network here: http://oit.gatech.edu/service/vpn/vpn-service-remote-access).

One problem is the GT FHIR API seems to be returning JSON files instead of the
text directly, which Bo asked about on Piazza here but it wasn't addressed:
https://piazza.com/class/i4eoysegvxp2db?cid=202

I choose JSON out of personal preference, but we could also do XML (which the
GT FHIR server seems to be providing normally).

GT FHIR server base URL:
https://taurus.i3l.gatech.edu:8443/HealthPort/fhir/

Due to the GT FHIR API server's lack of reliability we may also use the HAPI FHIR server:

HAPI: 

There are four types of FHIR resources available to us for our project:

1. Patient (list only no search filter)
2. Observation (with search filter: PatientID and Coding System)
3. Condition (with search filter: PatientID and Coding System)
4. MedicationPrescription (with search filter: PatientID and Coding System)

### 1. Patient

#### Get JSON of all patients

`https://taurus.i3l.gatech.edu:8443/HealthPort/fhir/Patient?_format=json`

#### Get JSON for patient with id = 3.358020000-01

`https://taurus.i3l.gatech.edu:8443/HealthPort/fhir/Patient/3.358020000-01?_format=json`

### 2. Observation

#### Get JSON of all observations (caution:expensive query)

`https://taurus.i3l.gatech.edu:8443/HealthPort/fhir/Observation?_format=json`

#### Get JSON of observations for patient 3.358020000-01

`https://taurus.i3l.gatech.edu:8443/HealthPort/fhir/Observation?subject=Patient/3.358020000-01&_format=json`

### 3. Condition

#### Get JSON of all conditions

`https://taurus.i3l.gatech.edu:8443/HealthPort/fhir/Condition?_format=json`

#### Get JSON of conditions for patient 3.358020000-01

`https://taurus.i3l.gatech.edu:8443/HealthPort/fhir/Condition?subject=Patient/3.358020000-01&_format=json`

### 4. Medication Prescription

#### Get JSON of all Medication Prescriptions

`https://taurus.i3l.gatech.edu:8443/HealthPort/fhir/MedicationPrescription?_format=json`

#### Get JSON of medication prescriptions for patient 3.358020000-01

`https://taurus.i3l.gatech.edu:8443/HealthPort/fhir/MedicationPrescription?subject=Patient/3.358020000-01&_format=json`

## Recommended FHIR Data Usage for Handoff

I recommend that we create a hand full of physician Handoff demo accounts, and
cherry pick a few (~20) patient IDs to associate to each of those accounts
(which is representative of those being the patients that see those doctors, so
those doctors already have HIPAA release so see that patient's data).

Loading the list of X patients for a doctor will require X calls to the API,
each for a specific patient (returning data like their name). This is preferred
to getting all of the patients and then sorting through them.

Loading a Handoff for a particular patient will require 3 additional calls to
the API to get the observations, conditions, and medical prescriptions for a
given patient (assuming the patient data was passed from the list).
