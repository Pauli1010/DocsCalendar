# Thought process

## Users

Users authentication is handled by light weighted Sorcery gem.
Seeeder creates one Admin user, who can update `Users` and `Doctors` data freely.

Normal users after authentication have access to logic connected with their own data manipulation, 
as well Slots that are open or reserved by them.

### Authentication 

For authentication User needs to make api call:

```
[POST] http://[::1]:3000//api/v1/registrations/create?user_email={email}
```

As response Api returns json with message, and sends email with link to authenticate without password.
Link can be called in api:

```
[POST] http://[::1]:3000/api/v1/sessions/create?login_token=
```

Based on login_token user_id is saved in Rails session_cookie.
Until session is maintained (and cookie does not expire), user has access to all actions requiring Authentication.

--- Functionality lacks tests.

## Slots and Doctors

Instead of creating slots when User wants to reserve an appointment, Slots are being generated by a method `#create_slots`
currently placed in `Doctor` model. By default, Slots are being created for next two weeks (including Date.current - so 15 days),
based on weekly schedule that is saved in `working_days_summary` jsonb field in doctors table.
`#create_slots` method iterates through all 15 days, skipping those, for which Slots were already created[1], and creates new ones if `working_days_summary`
states that for specific day of the week there can be slots added.
This way we have control over how many slots for each doctor we open for Users, and we can easily create more slots based on the same pattern.

### EXAMPLE:
doctor_1 states that he has only three schedule_slots on Monday:
``` 
{ 'Monday' => {
    'slots' => [ 
        [slot_one_stat_time, slot_one_end_time], 
        [slot_two_stat_time, slot_two_end_time], 
        [slot_three_stat_time, slot_three_end_time] 
    ]
}
```
Starting on Mon, 13 Nov 2023 we iterate till Mon, 27 Nov 2023. 
For each Monday in this period we create 3 slots with:
- doctor_id = doctor_1.id,
- occupancy = 'open' # default value
- slot_date = date of iterated Monday,
- start_time = slot_#{num}_stat_time,
- end_time = slot_#{num}_end_time

---

For further development, this method would be open for Adim users, to use api calls to create more slots. 
Currently it can only be triggered from rails console.

When User reserves, frees or updates Slot's user_message field, app updates existing slot, that was created before.

Doctor model holds simulation for specialisation, that preferably should be moved to dictionary type associated model.

Additionally occupancy field can hold value `vacation` that was not yet configured, but was supposed to give info to Administrators 
about Slot's that according to doctor's schedules were supposed to be open, but were blocked due to holidays or days off.

## Routes

Application has doubled routes that take the same parameters. Users can reach slots through doctors:

```
[POST] /api/v1/doctors/:doctor_id/slots/:id/reserve_slot
```

or directly by providing necessary parameters:

```
[POST] /api/v1/reserve_slot?doctor_id=&id=&user_email=
```

Based on further development one of them may be deprecated, but first one is more user friendly, while second can be better for 3rd party services.
Based on needs, one of them can be deprecated for Api v2.

No admin namesapace was added as for this simple app permissions are handled by Sorcery and Sorcery based methods.

For full list or available routes:

`bin/rails routes`

Routes were not cleaned and may lead to unexisting actions

## Queries

Because of lack of time queries were not prepared and methods return objects with default values.
Simple Query was added directly in controller for doctor api call:

```
[GET] http://[::1]:3000/api/v1/doctors/:doctor_id`
```

Here instead of `working_days_summary` jsonb data, more user friendly format of schedule is returned.

### EXAMPLE
![Screenshot 2023-11-13 at 04.43.30.png](..%2F..%2F..%2F..%2Fvar%2Ffolders%2Fvv%2Fnrdy2qld2f1fzc3pz2_1kgfc0000gq%2FT%2FTemporaryItems%2FNSIRD_screencaptureui_kP9yeM%2FScreenshot%202023-11-13%20at%2004.43.30.png)
<em>screen from Postman </em>

---
[1] After implementing update mechanism for working_days_summary jsonb field, triggering `#create_slots` should verify 
if currently created slots for picked timeframe, should be removed (for example because of Modnay no longer being in Doctor's schedule) 
and users that have reserved the appointment should receive email about slot no longer being available.