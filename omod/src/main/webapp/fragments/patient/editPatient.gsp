<%
    ui.decorateWith("kenyaui", "panel", [heading: (config.heading ?: "Edit Patient"), frameOnly: true])
    def countyName = command.personAddress.countyDistrict
    def country = command.personAddress.country
    def subCounty = command.personAddress.stateProvince
    def nokRelationShip = command.nextOfKinRelationship
    def kDoDCadre = command.kDoDCadre
    def kDoDRank = command.kDoDRank
    def kDoDUnit = command.kDoDUnit
    def ward = command.personAddress.address4

    def nationalIdType = "49af6cdc-7968-4abb-bf46-de10d7f4859f"
    def birthCertificateNumberType = "68449e5a-8829-44dd-bfef-c9c8cf2cb9b2"
    def passportNumberType = "be9beef6-aacc-4e1f-ac4e-5babeaa1e303"
    def nameFields = [
            [
                    [object: command, property: "personName.familyName", label: "Surname *"],
                    [object: command, property: "personName.givenName", label: "First name *"],
                    [object: command, property: "personName.middleName", label: "Other name(s)"]
            ],
    ]

    def otherDemogFieldRows = [
            [
                    [object: command, property: "maritalStatus", label: "Marital status", config: [style: "list", options: maritalStatusOptions]],
                    [object: command, property: "occupation", label: "Occupation", config: [style: "list", options: occupationOptions]],
                    [object: command, property: "education", label: "Education", config: [style: "list", options: educationOptions]]
            ]
    ]

    def deathFieldRows = [
            [
                    [object: command, property: "dead", label: "Deceased"],
                    [object: command, property: "deathDate", label: "Date of death"]
            ]
    ]

    def nextOfKinFieldRows = [
            [
                    [object: command, property: "nextOfKinContact", label: "Phone Number"],
                    [object: command, property: "nextOfKinAddress", label: "Postal Address"]
            ]
    ]

    def contactsFields = [
            [
                    [object: command, property: "telephoneContact", label: "Telephone contact"],
                    [object: command, property: "alternatePhoneContact", label: "Alternate phone number"]
            ]
    ]
   def otherContactsFields = [         [
                    [object: command, property: "personAddress.address1", label: "Postal Address", config: [size: 60]],
                    [object: command, property: "emailAddress", label: "Email address"]
            ]
    ]

    def locationSubLocationVillageFields = [

            [
                    [object: command, property: "personAddress.address6", label: "Location"],
                    [object: command, property: "personAddress.address5", label: "Sub-location"],
                    [object: command, property: "personAddress.cityVillage", label: "Village"]
            ]
    ]

    def landmarkNearestFacilityFields = [

            [
                    [object: command, property: "personAddress.address2", label: "Landmark"],
                    [object: command, property: "nearestHealthFacility", label: "Nearest Health Center"]
            ]
    ]
    def chtDetailsFields = [
            [
                    [object: command, property: "chtReferenceNumber", label: "CHT Username"]
            ]
    ]
    def kDoDUnitField = [
            [
                    [object: command, property: "kDoDUnit", label: "Unit *"]
            ]
    ]
    def crVerifedField = [
            [
                    [object: command, property: "CRVerificationStatus", label: "CR Verifed"]
            ]
    ]
%>
<script type="text/javascript" src="/${ contextPath }/moduleResources/kenyaemr/scripts/KenyaAddressHierarchy.js"></script>

<form id="edit-patient-form" method="post" action="${ui.actionLink("kenyaemr", "patient/editPatient", "savePatient")}">
    <% if (command.original) { %>
    <input type="hidden" name="personId" value="${command.original.id}"/>
    <% } %>

    <div class="ke-panel-content">

        <fieldset>
            <legend>Client verification with Client Registry</legend>
            <table>
                <tr>
                    <td>Identifier Type</td>
                    <td>
                        <select id="idType" name="idtype">
                            <option value="">Select a valid identifier type</option>
                            <% idTypes.each {%>
                            <% if(it.uuid == nationalIdType || it.uuid == birthCertificateNumberType || it.uuid == passportNumberType) { %>
                            <option value="${it.uuid}">${it.name}</option>
                            <% } %>
                            <%}%>
                        </select>
                    </td>
                    <td>
                        <input type="text" id="idValue" name="idValue" />
                    </td>
                    <td class="ke-field-instructions">
                        <div class="buttons-validate-identifiers">
                            <button type="button" class="ke-verify-button" id="validate-identifier">Validate Identifier</button>
                            <div class="wait-loading"></div>
                            <button type="button" class="ke-verify-button" id="show-cr-info-dialog">View Registry info</button>
                            <div class="message-validate-identifiers">
                                <label id="msgBox"></label>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr></tr>

            </table>
        </fieldset>
        <div class="ke-form-globalerrors" style="display: none"></div>

        <div class="ke-form-instructions">
            <strong>*</strong> indicates a required field
        </div>

        <fieldset id="identifiers">
            <legend>ID Numbers</legend>

            <table>
                <% if (command.inHivProgram && isKDoD==false) { %>
                <tr>
                    <td class="ke-field-label">Unique Patient Number</td>
                    <td>${
                            ui.includeFragment("kenyaui", "widget/field", [object: command, property: "uniquePatientNumber"])}</td>
                    <td class="ke-field-instructions">(HIV program<% if (!command.uniquePatientNumber) { %>, if assigned<%
                            } %>)</td>
                </tr>

                <% } %>
                <% if(enableClientNumberField || command.clientNumber) { %>
                <tr>
                    <td class="ke-field-label">${clientNumberLabel}</td>
                    <td>${ui.includeFragment("kenyaui", "widget/field", [object: command, property: "clientNumber"])}</td>
                    <td class="ke-field-instructions"><% if (!command.clientNumber) { %>(This is a generic partner identification for clients. Please only provide if available)<%
                            } %></td>
                </tr>

                <% } %>


                <tr>
                    <td class="ke-field-label">Patient Clinic Number</td>
                    <td>${ui.includeFragment("kenyaui", "widget/field", [object: command, property: "patientClinicNumber"])}</td>
                    <td class="ke-field-instructions"><% if (!command.patientClinicNumber) { %>(if available)<%
                        } %></td>
                </tr>
                <tr>
                    <td class="ke-field-label">National ID Number</td>
                    <td>${ui.includeFragment("kenyaui", "widget/field", [object: command, property: "nationalIdNumber"])}</td>
                    <td class="ke-field-instructions"><% if (!command.nationalIdNumber) { %>(This is required for all kenyans aged 18+)<% } %></td>
                    <td><div id="nationalID-msgBox" class="ke-warning">Please enter National Id or Birth Certificate Number to post to CR</div></td>
                </tr>

                <tr  id="birth-cert-no">
                    <td class="ke-field-label">Birth Certificate Number</td>
                    <td>${ui.includeFragment("kenyaui", "widget/field", [object: command, property: "birthCertificateNumber"])}</td>
                    <td class="ke-field-instructions"><% if (!command.birthCertificateNumber) { %>(if available or Birth Notification number)<% } %></td>
                </tr>
                <tr id="upi-no">
                    <td class="ke-field-label">NUPI</td>
                    <td>${ui.includeFragment("kenyaui", "widget/field", [object: command, property: "nationalUniquePatientNumber"])}</td>
                    <td class="ke-field-instructions"> This will be populated from MOH Client Registry</td>
                </tr>
                <tr></tr>
                <tr>
                    <td> <input type="checkbox" name="other-identifiers" value="Y"
                                id="other-identifiers" /> More identifiers </td>
                </tr>
                <tr></tr>
                <tr id="passport-no">
                    <td class="ke-field-label">Passport Number</td>
                    <td>${ui.includeFragment("kenyaui", "widget/field", [object: command, property: "passPortNumber"])}</td>
                    <td class="ke-field-instructions"><% if (!command.passPortNumber) { %>(if available)<% } %></td>
                </tr>
                <tr id="huduma-no">
                    <td class="ke-field-label">Huduma Number</td>
                    <td>${ui.includeFragment("kenyaui", "widget/field", [object: command, property: "hudumaNumber"])}</td>
                    <td class="ke-field-instructions"><% if (!command.hudumaNumber) { %>(if available)<% } %></td>
                </tr>
                <tr id="alien-no">
                    <td class="ke-field-label">Alien ID Number</td>
                    <td>${ui.includeFragment("kenyaui", "widget/field", [object: command, property: "alienIdNumber"])}</td>
                    <td class="ke-field-instructions"><% if (!command.alienIdNumber) { %>(if available)<% } %></td>
                </tr>
                <tr id="driving-license">
                    <td class="ke-field-label">Driving License Number</td>
                    <td>${ui.includeFragment("kenyaui", "widget/field", [object: command, property: "drivingLicenseNumber"])}</td>
                    <td class="ke-field-instructions"><% if (!command.drivingLicenseNumber) { %>(if available)<% } %></td>
                </tr>

                <tr id="kdod-service-no">
                    <td class="ke-field-label">Service Number *</td>
                    <td>${ui.includeFragment("kenyaui", "widget/field", [object: command, property: "kDoDServiceNumber"])}</td>
                    <td class="ke-field-instructions"><% if (!command.kDoDServiceNumber) { %>(5-6 digits for service officer or 5-6 digits followed by / and 2 digits for dependant(eg.12345/01))<%} %></td>
                </tr>

            </table>

        </fieldset>

        <fieldset>
            <legend>Demographics</legend>

            <% nameFields.each { %>
            ${ui.includeFragment("kenyaui", "widget/rowOfFields", [fields: it])}
            <% } %>
            &nbsp;&nbsp;
            <table>
               <tr>
                <td>
                    <div id="surname-msgBox" class="ke-warning">Please enter Surname to post to CR</div>
                </td>
                   <td>
                       <div id="firstname-msgBox" class="ke-warning">Please enter First name to post to CR</div>
                   </td>
                </tr>
            </table>
            <table>
                <tr>
                    <td valign="top">
                        <label class="ke-field-label">Sex *</label>
                        <span class="ke-field-content">
                            <input type="radio" name="gender" value="F"
                                   id="gender-F" ${command.gender == 'F' ? 'checked="checked"' : ''}/> Female
                            <input type="radio" name="gender" value="M"
                                   id="gender-M" ${command.gender == 'M' ? 'checked="checked"' : ''}/> Male
                            <span id="gender-F-error" class="error" style="display: none"></span>
                            <span id="gender-M-error" class="error" style="display: none"></span>
                        </span>
                    </td>
                    <td>
                        <div id="gender-msgBox" class="ke-warning">Please enter Age to post to CR</div>
                    </td>
                    <td valign="top"></td>
                    <td valign="top">
                        <label class="ke-field-label">Date of Birth *</label>
                        <span class="ke-field-content">
                            ${ui.includeFragment("kenyaui", "widget/field", [id: "patient-birthdate", object: command, property: "birthdate"])}
                            <span id="patient-birthdate-estimated">
                                <input type="radio" name="birthdateEstimated"
                                       value="true" ${command.birthdateEstimated ? 'checked="checked"' : ''}/> Estimated
                                <input type="radio" name="birthdateEstimated"
                                       value="false" ${!command.birthdateEstimated ? 'checked="checked"' : ''}/> Exact
                            </span>
                            &nbsp;&nbsp;&nbsp;

                            <span id="from-age-button-placeholder"></span>
                        </span>
                    </td>
                    <td>
                        <div id="age-msgBox" class="ke-warning">Please enter Age to post to CR</div>
                    </td>
                </tr>
            </table>

            <% otherDemogFieldRows.each { %>
            ${ui.includeFragment("kenyaui", "widget/rowOfFields", [fields: it])}
            <% } %>

            <table id ="kdod-struct">
                <tr>
                    <td id="cadre" class="ke-field-label" style="width: 70px">Cadre *</td>
                    <td id="rank" class="ke-field-label" style="width: 70px">Rank *</td>
                </tr>

                <tr>
                    <td style="width: 70px">
                        <select name="kDoDCadre">
                            <option></option>
                            <%cadreOptions.each { %>
                            <option ${!kDoDCadre? "" : it.trim().toLowerCase() == kDoDCadre.trim().toLowerCase() ? "selected" : ""} value="${it}">${it}</option>
                            <%}%>
                        </select>
                    </td>
                    <td style="width: 70px">
                        <select name="kDoDRank" class ="kDoDRank">
                            <option></option>
                            <%rankOptions.each { %>
                            <option ${!kDoDRank? "" : it.trim().toLowerCase() == kDoDRank.trim().toLowerCase() ? "selected" : ""} value="${it}">${it}</option>
                            <%}%>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td id="unit" class="ke-field-label" style="width: 70px">Unit *</td>
                </tr>
                <tr>
                    <td style="width: 200px" id="kdod-unit">
                        <input name="kDoDUnit" class ="kDoDUnit" ${(command.kDoDUnit != null)? command.kDoDUnit : ""}/>

                    </td>
                </tr>
            </table>

            <% deathFieldRows.each { %>
            ${ui.includeFragment("kenyaui", "widget/rowOfFields", [fields: it])}
            <% } %>

        </fieldset>

    </fieldset>
        <fieldset>
            <legend>Address</legend>
            <table>
            <tr>
            <td class="ke-field-label">Country</td>
            <td> </td>
            </tr>
            <tr>
                
                <td>${ui.includeFragment("kenyaui", "widget/field", [object: command, property: "country", config: [style: "list", options: countryOptions]])}</td>
                <td> <input type="checkbox" name="select-kenya-option" value="Y" id="select-kenya-option" /> Select Kenya </td>
               
            </tr>
            </table>

            <% contactsFields.each { %>
            ${ui.includeFragment("kenyaui", "widget/rowOfFields", [fields: it])}
            <% } %>
            <table>
            <tr>
                <td>
                    <div id="country-msgBox" class="ke-warning">Please enter Country to post to CR</div>
                </td>
                <td>
                    <div id="phone-msgBox" class="ke-warning">Please enter Phone number to post to CR</div>
                </td>
            </tr>
           </table>
            <% otherContactsFields.each { %>
            ${ui.includeFragment("kenyaui", "widget/rowOfFields", [fields: it])}
            <% } %>
            <table>
                <tr>
                    <td class="ke-field-label" style="width: 265px">County</td>
                    <td class="ke-field-label" style="width: 260px">Sub-County</td>
                    <td class="ke-field-label" style="width: 260px">Ward</td>
                </tr>

                <tr>
                    <td style="width: 265px">
                        <select id="county" name="personAddress.countyDistrict">
                            <option></option>
                            <%countyList.each { %>
                            <option ${!countyName? "" : it.trim().toLowerCase() == countyName.trim().toLowerCase() ? "selected" : ""} value="${it}">${it}</option>
                            <%}%>
                        </select>
                    </td>
                    <td style="width: 260px">
                        <select id="subCounty" name="personAddress.stateProvince">
                            <option></option>
                        </select>
                    </td>
                    <td style="width: 260px">
                        <select id="ward" name="personAddress.address4">
                            <option></option>
                        </select>
                    </td>
                </tr>
            <tr>
                <td>
                    <div id="county-msgBox" class="ke-warning">Please enter County to post to CR</div>
                </td>
                <td>
                    <div id="subCounty-msgBox" class="ke-warning">Please enter Sub County to post to CR</div>
                </td>
                <td>
                    <div id="ward-msgBox" class="ke-warning">Please enter Ward to post to CR</div>
                </td>
            </tr>
            </table>
            <% locationSubLocationVillageFields.each { %>
            ${ui.includeFragment("kenyaui", "widget/rowOfFields", [fields: it])}
            <% } %>

            <% landmarkNearestFacilityFields.each { %>
            ${ui.includeFragment("kenyaui", "widget/rowOfFields", [fields: it])}
            <% } %>
        </fieldset>

        <% if (peerEducator) { %>
        <fieldset>
            <legend>CHT Details</legend>
            <table>
                <tr>
                    <td valign="top">
                        <% chtDetailsFields.each { %>
                        ${ui.includeFragment("kenyaui", "widget/rowOfFields", [fields: it])}
                        <% } %>
                    </td>
                </tr>
            </table>
            <%} %>

        </fieldset>
        <fieldset>
            <legend>Next of Kin Details</legend>
            <table>
                <tr>
                    <td class="ke-field-label" style="width: 260px">Name</td>
                    <td class="ke-field-label" style="width: 260px">Relationship</td>
                </tr>

                <tr>
                    <td style="width: 260px">${ui.includeFragment("kenyaui", "widget/field", [object: command, property: "nameOfNextOfKin"])}</td>
                    <td style="width: 260px">
                        <select name="nextOfKinRelationship">
                            <option></option>
                            <%nextOfKinRelationshipOptions.each { %>
                            <option ${!nokRelationShip? "" : it.trim().toLowerCase() == nokRelationShip.trim().toLowerCase() ? "selected" : ""} value="${it}">${it}</option>
                            <%}%>
                        </select>
                    </td>
                </tr>
            </table>
            <% nextOfKinFieldRows.each { %>
            ${ui.includeFragment("kenyaui", "widget/rowOfFields", [fields: it])}
            <% } %>

            <% crVerifedField.each { %>
            ${ui.includeFragment("kenyaui", "widget/rowOfFields", [fields: it])}
            <% } %>


        </fieldset>

        <div align="center" id="post-msgBox"></div>
        <br/>

        <fieldset>
            <div class="ke-panel-footer centre-content">
                <div class="buttons-post-create-patient centre-content">
                    <button type="button" id="post-registrations" style="margin-right: 5px; margin-left: 5px;">
                        <img src="${ui.resourceLink("kenyaui", "images/glyphs/ok.png")}"/> Post to Registry
                    </button>
                    <div class="wait-loading-post-registration"></div>
                    <button type="submit" id="createPatientBtn" style="margin-right: 5px; margin-left: 5px;">
                        <img src="${ui.resourceLink("kenyaui", "images/glyphs/ok.png")}"/> ${command.original ? "Save Changes" : "Create Patient"}
                    </button>
                    <% if (config.returnUrl) { %>
                    <button type="button" class="cancel-button" style="margin-right: 5px; margin-left: 5px;"><img
                            src="${ui.resourceLink("kenyaui", "images/glyphs/cancel.png")}"/> Cancel</button>
                    <% } %>
                </div>
            </div>
        </fieldset>
        
    </div>

</form>

<div id="cr-dialog" title="Patient Overview" style="display: none; background-color: white; padding: 10px;">
    <div id="client-registry-info">

        <fieldset>
            <legend>Client name</legend>
            <table>
                <tr>
                    <td width="250px">Full name</td>
                    <td id="cr-full-name" width="200px"></td>
                    <td><button id="use-full-name" type="button" onclick="useDemographics()">Use all values in form</button></td>
                </tr>
                <tr>
                    <td>Sex</td>
                    <td id="cr-sex"></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Primary phone Number</td>
                    <td id="cr-primary-contact"></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Secondary phone</td>
                    <td id="cr-secondary-contact"></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Email address</td>
                    <td id="cr-email"></td>
                    <td></td>
                </tr>
            </table>
        </fieldset>
        <fieldset>
            <legend>Client identifiers</legend>
            <table>
                <tr>
                    <td width="250px">UPI</td>
                    <td id="cr-upi" width="200px"></td>
                    <td><button type="button" onclick="useIdentifiers()">Use all values in form</button></td>
                </tr>
                <tr>
                    <td>National ID</td>
                    <td id="cr-national-id"></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Passport Number</td>
                    <td id="cr-passport"></td>
                    <td></td>
                </tr>
            </table>
        </fieldset>
        <fieldset>
            <legend>Address</legend>
            <table>
                <tr>
                    <td width="250px">County</td>
                    <td id="cr-county" width="200px"></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Sub county</td>
                    <td id="cr-sub-county"></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Ward</td>
                    <td id="cr-ward"></td>
                    <td></td>
                </tr>
            </table>
        </fieldset>
        <fieldset>
            <legend>Next of kin</legend>
            <table>
                <tr>
                    <td width="250px">Name</td>
                    <td id="cr-kin-name" width="200px"></td>
                    <td><button type="button" onclick="useNextofKin()">Use all values in form</button></td>
                </tr>
                <tr>
                    <td>Relationship</td>
                    <td id="cr-kin-relation"></td>
                    <td></td>
                </tr>
                <tr>
                    <td>Phone number</td>
                    <td id="cr-kin-contact"></td>
                    <td></td>
                </tr>
            </table>
        </fieldset>
    </div>
    <div align="center">
        <button type="button" onclick="kenyaui.closeDialog();"><img src="${ ui.resourceLink("kenyaui", "images/glyphs/cancel.png") }" /> Close</button>
    </div>
</div>

<!-- You can't nest forms in HTML, so keep the dialog box form down here -->
${ui.includeFragment("kenyaui", "widget/dialogForm", [
        buttonConfig     : [id: "from-age-button", label: "from age", iconProvider: "kenyaui", icon: "glyphs/calculate.png"],
        dialogConfig     : [heading: "Calculate Birthdate", width: 40, height: 40],
        fields           : [
                [label: "Age in years", formFieldName: "age", class: java.lang.Integer],
                [
                        label: "On date", formFieldName: "now",
                        class: java.util.Date, initialValue: new java.text.SimpleDateFormat("yyyy-MM-dd").parse((new Date().getYear() + 1900) + "-06-15")
                ]
        ],
        fragmentProvider : "kenyaemr",
        fragment         : "emrUtils",
        action           : "birthdateFromAge",
        onSuccessCallback: "updateBirthdate(data);",
        onOpenCallback   : """jQuery('input[name="age"]').focus()""",
        submitLabel      : ui.message("general.submit"),
        cancelLabel      : ui.message("general.cancel")
])}

<style>
.ke-cr-client-exists {
    padding: 10px 20px;
    background-color: yellowgreen;
    color: #ffffff;
    font-weight: 200;
}

.ke-cr-client-not-found {
    padding: 10px 20px;
    background-color: darkred;
    color: #ffffff;
    font-weight: 200;
}

.wait-loading {
    margin-right: 5px;
    margin-left: 5px;
}

.buttons-validate-identifiers {
    float: left;
}

.buttons-validate-identifiers *{
    display: inline-block;
}

.message-validate-identifiers {
    margin-right: 5px;
    margin-left: 5px;
}

.buttons-post-create-patient {
    float: left;
}

.buttons-post-create-patient *{
    display: inline-block;
    margin: 0 auto;
}

.centre-content {
    display: flex;
    justify-content: center;
}

.ke-cr-network-error {
    padding: 10px 20px;
    background-color: red;
    color: #ffffff;
    font-weight: 200;
}

.ke-verify-button {
    padding: 10px 20px;
    border-radius: 5px;
    background-color: #155cd2;
    color: #ffffff;
    /*font-family: Montserrat;*/
    font-size: 16px;
    font-weight: 200;
}

.ke-verify-button:hover {
    background-color:#002ead;
    transition: 0.7s;
}
</style>
<script type="text/javascript">
    //On ready
    crResponseData = ""; // response from client registry
    var loadingImageURL = ui.resourceLink("kenyaemr", "images/loading.gif");
    var showLoadingImage = '<span style="padding:2px; display:inline-block;"> <img src="' + loadingImageURL + '" /> </span>';

    jQuery(function () {

        //var loadingImageURL = ui.resourceLink("kenyaemr", "images/loading.gif");
        //var showLoadingImage = '<span style="padding:2px; display:inline-block;"> <img src="' + loadingImageURL + '" /> </span>';

        function display_loading_validate_identifier(status) {
            if(status) {
                jq('.wait-loading').empty();
                jq('.wait-loading').append(showLoadingImage);
            } else {
                jq('.wait-loading').empty();
            }
        }

        jQuery('input[name="nationalUniquePatientNumber"]').attr('readonly', true);
        jQuery('#createPatientBtn').prop('disabled', true);
        jQuery('#alien-no').hide();
        jQuery('#huduma-no').hide();
        jQuery('#passport-no').hide();
        jQuery('#driving-license').hide();
        jQuery("#post-msgBox").hide();
        jQuery("#surname-msgBox").hide();
        jQuery("#firstname-msgBox").hide();
        jQuery("#age-msgBox").hide();
        jQuery("#gender-msgBox").hide();
        jQuery("#country-msgBox").hide();
        jQuery("#phone-msgBox").hide();
        jQuery("#county-msgBox").hide();
        jQuery("#subCounty-msgBox").hide();
        jQuery("#ward-msgBox").hide();
        jQuery("#nationalID-msgBox").hide();

        jQuery('#show-cr-info-dialog').hide();
        jQuery('#other-identifiers').click(otherIdentifiersChange);
        jQuery('#show-cr-info-dialog').click(showDataFromCR);
        jQuery('#use-full-name').click(useFullName);
        jQuery('#select-kenya-option').click(selectCountryKenyaOption);
        jQuery('#validate-identifier').click(function(event){

            // connect to dhp server
            var authToken = '${clientVerificationApiToken}';
            var idType = jQuery('#idType').val();
            var idValue = jQuery('input[name=idValue]').val();
            var idTypeParam = '';

            if (authToken == '') {
                jQuery('#show-cr-info-dialog').hide();
                var className = jQuery('#msgBox').attr("class");
                jQuery('#msgBox').removeClass(className);
                //jQuery('#msgBox').addClass('ke-cr-client-not-found');
                jQuery('#msgBox').text('Please notify the system admin to enable verification process');
                return;
            }

            if (idType == '' || idValue == '') {
                jQuery('#show-cr-info-dialog').hide();
                var className = jQuery('#msgBox').attr("class");
                jQuery('#msgBox').removeClass(className);
                //jQuery('#msgBox').addClass('ke-cr-client-not-found');
                jQuery('#msgBox').text('Please specify identifier type and value for verification');
                return;
            }


            if(idType == '${nationalIdType}') {
                idTypeParam = 'national-id';
            } else if (idType == '${passportNumberType}') {
                idTypeParam = 'passport-id';
            } else if (idType == '${birthCertificateNumberType}') {
                idTypeParam = 'birth-certificate';
            }

            var baseVerificationUrl = '${clientVerificationApi}';
            var getUrl = baseVerificationUrl + idTypeParam + '/' +  idValue;

            // show spinner
            display_loading_validate_identifier(true);

            jq.ajax({
                url: getUrl,
                type: "GET",
                async: true, // asynchronous
                timeout: 10000, // 10 sec timeout
                headers: { Authorization: 'Bearer ' + authToken},
                error: function(err) {
                    // hide spinner
                    display_loading_validate_identifier(false);

                    var className = jQuery('#msgBox').attr("class");
                    jQuery('#msgBox').removeClass(className);
                    jQuery('#msgBox').addClass('ke-cr-network-error');
                    switch (err.status) {
                        case "400":
                            // bad request
                            jQuery('#msgBox').text('A network error occured: 400 - Bad Request');
                            break;
                        case "401":
                            // expired or invalid token
                            jQuery('#msgBox').text('A network error occured: 401 - Invalid Token');
                            break;
                        case "403":
                            // forbidden
                            jQuery('#msgBox').text('A network error occured: 403 - Forbidden');
                            break;
                        default:
                            //Something bad happened
                            jQuery('#msgBox').text('A network error occured: ' + err.status);
                            break;
                    }
                },
                success: function(data) {
                    // hide spinner
                    display_loading_validate_identifier(false);

                    crResponseData = data;
                    if(data.clientExists) {
                        var className = jQuery('#msgBox').attr("class");
                        jQuery('#msgBox').removeClass(className);
                        jQuery('#msgBox').addClass('ke-cr-client-exists');
                        jQuery('#msgBox').text('Client exists in the registry. UPI number:  ' + data.client.clientNumber);

                        // unset vars
                        jQuery('#cr-full-name').text("");
                        jQuery('#cr-sex').text("");
                        jQuery('#cr-primary-contact').text("");
                        jQuery('#cr-secondary-contact').text("");
                        jQuery('#cr-email').text("");

                        jQuery('#cr-county').text("");
                        jQuery('#cr-sub-county').text("");
                        jQuery('#cr-ward').text("");

                        jQuery('#cr-kin-name').text("");
                        jQuery('#cr-kin-relation').text("");
                        jQuery('#cr-kin-contact').text("");
                        jQuery('#cr-national-id').text("");
                        jQuery('#cr-upi').text("");

                        //
                        jQuery('#cr-full-name').text(data.client.firstName + ' ' + data.client.middleName + ' ' + data.client.lastName);
                        jQuery('#cr-sex').text(data.client.gender);
                        jQuery('#cr-primary-contact').text(data.client.contact.primaryPhone);
                        jQuery('#cr-secondary-contact').text(data.client.contact.secondaryPhone);
                        jQuery('#cr-email').text(data.client.contact.emailAddress);

                        // residence
                        jQuery('#cr-county').text(data.client.residence.county);
                        jQuery('#cr-sub-county').text(data.client.residence.subCounty);
                        jQuery('#cr-ward').text(data.client.residence.ward);

                        // next of kin

                        if(data.client.nextOfKins.length > 0) {
                            var nextOfKin = data.client.nextOfKins[0];
                            jQuery('#cr-kin-name').text(nextOfKin.name);
                            jQuery('#cr-kin-relation').text(nextOfKin.relationship);
                            jQuery('#cr-kin-contact').text(nextOfKin.contact.primaryPhone);

                        }

                        // identifiers
                        jQuery('#cr-upi').text(data.client.clientNumber); // update UPI field
                        if (data.client.identifications.length > 0) {
                            for (i = 0; i < data.client.identifications.length; i++) {
                                var identifierObj = data.client.identifications[i];
                                if (identifierObj.identificationType == 'Identification Number') {
                                    jQuery('#cr-national-id').text(identifierObj.identificationNumber);
                                }
                            }
                        }

                        jQuery('#show-cr-info-dialog').show();

                    } else {
                        jQuery('#show-cr-info-dialog').hide();
                        var className = jQuery('#msgBox').attr("class");
                        jQuery('#msgBox').removeClass(className);
                        jQuery('#msgBox').addClass('ke-cr-client-not-found');
                        jQuery('#msgBox').text('Client not found in the registry. Please enter registration data and post to CR ');
                    }
                }
            });

            //
        });

        //Prepare UPI payload

        jQuery('#post-registrations').click(function(){

            //Enable Create patient button
            jQuery('#createPatientBtn').prop('disabled', false);

            //Identifiers:
            var identifierType;
            var identifierValue;
            if(jQuery('input[name=nationalIdNumber]').val() !=""){
                identifierType = "national-id";
                identifierValue = jQuery('input[name=nationalIdNumber]').val();
                jQuery("#nationalID-msgBox").hide();
            }else if(jQuery('input[name=birthCertificateNumber]').val() !=""){
                identifierType = "birth-certificate";
                identifierValue = jQuery('input[name=birthCertificateNumber]').val();
                jQuery("#nationalID-msgBox").hide();
            }else{
                jQuery("#post-msgBox").text("Please enter National Id or Birth Certificate Number to successfully post to CR");
                jQuery("#post-msgBox").show();
                jQuery("#nationalID-msgBox").show();
            }
                //gender:
                var gender;
                if(jQuery('input[name=gender]').val() !="") {
                    jQuery("#gender-msgBox").hide();
                    if (jQuery('input[name=gender]').val() == "F") {
                        gender = "female";
                    }
                    if (jQuery('input[name=gender]').val() == "M") {
                        gender = "male";
                    }
                }else{
                    jQuery("#post-msgBox").text("Please enter gender to successfully post to CR");
                    jQuery("#post-msgBox").show();
                    jQuery("#gender-msgBox").show();
                }
            //Marital status:
            var maritalStatus;
            if(jQuery('select[name=maritalStatus]').val() !=""){
                if(jQuery('select[name=maritalStatus]').val() == 159715){
                    maritalStatus = "married";
                }
                if(jQuery('select[name=maritalStatus]').val() == 5555){
                    maritalStatus = "married";
                }
                if(jQuery('select[name=maritalStatus]').val() == 1060){
                    maritalStatus = "married";
                }
                if(jQuery('select[name=maritalStatus]').val() == 1057){
                    maritalStatus = "single";
                }
                if(jQuery('select[name=maritalStatus]').val() == 1058){
                    maritalStatus = "divorced";
                }
                if(jQuery('select[name=maritalStatus]').val() == 1059){
                    maritalStatus = "widowed";
                }
              }

            //Occupation status:
            var occupationStatus;
            if(jQuery('select[name=occupation]').val() !=""){
                if(jQuery('select[name=occupation]').val() == 159465){
                    occupationStatus = "student";
                }
                if(jQuery('select[name=occupation]').val() == 1538){
                    occupationStatus = "farmer";
                }
                if(jQuery('select[name=occupation]').val() == 1539){
                    occupationStatus = "banker";
                }
                if(jQuery('select[name=occupation]').val() == 1540){
                    occupationStatus = "doctor";
                }
                if(jQuery('select[name=occupation]').val() == 159466){
                    occupationStatus = "mechanic";
                }
                if(jQuery('select[name=occupation]').val() == 1107){
                    occupationStatus = "student";
                }
            }
            //Education status:
            var educationStatus;
            if(jQuery('select[name=education]').val() !=""){
                if(jQuery('select[name=education]').val() == 1107){
                    educationStatus = "primary";
                }
                if(jQuery('select[name=education]').val() == 1713){
                    educationStatus = "primary";
                }
                if(jQuery('select[name=education]').val() == 1714){
                    educationStatus = "secondary";
                }
                if(jQuery('select[name=education]').val() == 159785){
                    educationStatus = "college";
                }
            }
            var countryCode;
            if(jQuery('select[name=country]').val() !=""){
                jQuery("#country-msgBox").hide();
                if(jQuery('select[name=country]').val() == 162883){
                    countryCode = "KE";
                }
                if(jQuery('select[name=country]').val() == 162884){
                    countryCode = "UG";
                }
                if(jQuery('select[name=country]').val() == 165639){
                    countryCode = "TZ";
                }
                if(jQuery('select[name=country]').val() == 165705){
                    countryCode = "AF";
                }
                if(jQuery('select[name=country]').val() == 165674){
                    countryCode = "AL";
                }

                if(jQuery('select[name=country]').val() == 165757){
                    countryCode = "DZ";
                }

                if(jQuery('select[name=country]').val() == 165691){
                    countryCode = "AD";
                }

                if(jQuery('select[name=country]').val() == 165774){
                    countryCode = "AO";
                }

                if(jQuery('select[name=country]').val() == 165798){
                    countryCode = "AG";
                }

                if(jQuery('select[name=country]').val() == 165821){
                    countryCode = "AR";
                }

                if(jQuery('select[name=country]').val() == 165675){
                    countryCode = "AM";
                }

                if(jQuery('select[name=country]').val() == 165742){
                    countryCode = "AU";
                }

                if(jQuery('select[name=country]').val() == 165666){
                    countryCode = "AT";
                }

                if(jQuery('select[name=country]').val() == 165676){
                    countryCode = "AZ";
                }

                if(jQuery('select[name=country]').val() == 165799){
                    countryCode = "BS";
                }

                if(jQuery('select[name=country]').val() == 165713){
                    countryCode = "BH";
                }

                if(jQuery('select[name=country]').val() == 165706){
                    countryCode = "BD";
                }

                if(jQuery('select[name=country]').val() == 165800){
                    countryCode = "BB";
                }

                if(jQuery('select[name=country]').val() == 165677){
                    countryCode = "BY";
                }

                if(jQuery('select[name=country]').val() == 165660){
                    countryCode = "BE";
                }

                if(jQuery('select[name=country]').val() == 165811){
                    countryCode = "BZ";
                }

                if(jQuery('select[name=country]').val() == 165776){
                    countryCode = "BJ";
                }

                if(jQuery('select[name=country]').val() == 165707){
                    countryCode = "BT";
                }

                if(jQuery('select[name=country]').val() == 165822){
                    countryCode = "BO";
                }

                if(jQuery('select[name=country]').val() == 165678){
                    countryCode = "BA";
                }

                if(jQuery('select[name=country]').val() == 165766){
                    countryCode = "BW";
                }

                if(jQuery('select[name=country]').val() == 165823){
                    countryCode = "BR";
                }

                if(jQuery('select[name=country]').val() == 165731){
                    countryCode = "BN";
                }

                if(jQuery('select[name=country]').val() == 165679){
                    countryCode = "BG";
                }

                if(jQuery('select[name=country]').val() == 165777){
                    countryCode = "BF";
                }

                if(jQuery('select[name=country]').val() == 165744){
                    countryCode = "BI";
                }

                if(jQuery('select[name=country]').val() == 165733){
                    countryCode = "KH";
                }

                if(jQuery('select[name=country]').val() == 165745){
                    countryCode = "CM";
                }

                if(jQuery('select[name=country]').val() == 165818){
                    countryCode = "CA";
                }

                if(jQuery('select[name=country]').val() == 165778){
                    countryCode = "CV";
                }

                if(jQuery('select[name=country]').val() == 165746){
                    countryCode = "CF";
                }

                if(jQuery('select[name=country]').val() == 165747){
                    countryCode = "TD";
                }

                if(jQuery('select[name=country]').val() == 165824){
                    countryCode = "CL";
                }

                if(jQuery('select[name=country]').val() == 165634){
                    countryCode = "CN";
                }

                if(jQuery('select[name=country]').val() == 165825){
                    countryCode = "CO";
                }

                if(jQuery('select[name=country]').val() == 165755){
                    countryCode = "KM";
                }

                if(jQuery('select[name=country]').val() == 165749){
                    countryCode = "CG";
                }

                if(jQuery('select[name=country]').val() == 165748){
                    countryCode = "CD";
                }

                if(jQuery('select[name=country]').val() == 165812){
                    countryCode = "CR";
                }

                if(jQuery('select[name=country]').val() == 165783){
                    countryCode = "CI";
                }

                if(jQuery('select[name=country]').val() == 165667){
                    countryCode = "HR";
                }

                if(jQuery('select[name=country]').val() == 165802){
                    countryCode = "CU";
                }

                if(jQuery('select[name=country]').val() == 165680){
                    countryCode = "CY";
                }

                if(jQuery('select[name=country]').val() == 165668){
                    countryCode = "CZ";
                }

                if(jQuery('select[name=country]').val() == 165661){
                    countryCode = "DK";
                }

                if(jQuery('select[name=country]').val() == 165762){
                    countryCode = "DJ";
                }

                if(jQuery('select[name=country]').val() == 165801){
                    countryCode = "DM";
                }

                if(jQuery('select[name=country]').val() == 165826){
                    countryCode = "EC";
                }

                if(jQuery('select[name=country]').val() == 165758){
                    countryCode = "EG";
                }

                if(jQuery('select[name=country]').val() == 165813){
                    countryCode = "SV";
                }

                if(jQuery('select[name=country]').val() == 165779){
                    countryCode = "GQ";
                }

                if(jQuery('select[name=country]').val() == 165642){
                    countryCode = "ER";
                }

                if(jQuery('select[name=country]').val() == 165681){
                    countryCode = "EE";
                }

                if(jQuery('select[name=country]').val() == 165641){
                    countryCode = "ET";
                }

                if(jQuery('select[name=country]').val() == 165663){
                    countryCode = "FI";
                }

                if(jQuery('select[name=country]').val() == 165658){
                    countryCode = "FR";
                }

                if(jQuery('select[name=country]').val() == 165750){
                    countryCode = "GA";
                }

                if(jQuery('select[name=country]').val() == 165790){
                    countryCode = "GM";
                }

                if(jQuery('select[name=country]').val() == 165682){
                    countryCode = "GE";
                }

                if(jQuery('select[name=country]').val() == 165659){
                    countryCode = "DE";
                }

                if(jQuery('select[name=country]').val() == 165780){
                    countryCode = "GH";
                }

                if(jQuery('select[name=country]').val() == 165683){
                    countryCode = "GR";
                }

                if(jQuery('select[name=country]').val() == 165803){
                    countryCode = "GD";
                }

                if(jQuery('select[name=country]').val() == 165814){
                    countryCode = "GT";
                }

                if(jQuery('select[name=country]').val() == 162607){
                    countryCode = "GN";
                }

                if(jQuery('select[name=country]').val() == 165782){
                    countryCode = "GW";
                }

                if(jQuery('select[name=country]').val() == 165827){
                    countryCode = "GY";
                }

                if(jQuery('select[name=country]').val() == 165804){
                    countryCode = "HT";
                }
                if(jQuery('select[name=country]').val() == 165815){
                    countryCode = "HN";
                }

                if(jQuery('select[name=country]').val() == 165704){
                    countryCode = "HK";
                }

                if(jQuery('select[name=country]').val() == 165669){
                    countryCode = "HU";
                }

                if(jQuery('select[name=country]').val() == 165665){
                    countryCode = "IS";
                }

                if(jQuery('select[name=country]').val() == 165708){
                    countryCode = "IN";
                }

                if(jQuery('select[name=country]').val() == 165735){
                    countryCode = "ID";
                }

                if(jQuery('select[name=country]').val() == 165636){
                    countryCode = "IR";
                }

                if(jQuery('select[name=country]').val() == 165714){
                    countryCode = "IQ";
                }

                if(jQuery('select[name=country]').val() == 165698){
                    countryCode = "IE";
                }

                if(jQuery('select[name=country]').val() == 165715){
                    countryCode = "IL";
                }

                if(jQuery('select[name=country]').val() == 165635){
                    countryCode = "IT";
                }

                if(jQuery('select[name=country]').val() == 165805){
                    countryCode = "JM";
                }

                if(jQuery('select[name=country]').val() == 165637){
                    countryCode = "JP";
                }

                if(jQuery('select[name=country]').val() == 165716){
                    countryCode = "JO";
                }

                if(jQuery('select[name=country]').val() == 165725){
                    countryCode = "KZ";
                }

                if(jQuery('select[name=country]').val() == 165703){
                    countryCode = "KP";
                }

                if(jQuery('select[name=country]').val() == 165638){
                    countryCode = "KR";
                }

                if(jQuery('select[name=country]').val() == 165717){
                    countryCode = "KW";
                }

                if(jQuery('select[name=country]').val() == 165726){
                    countryCode = "KG";
                }

                if(jQuery('select[name=country]').val() == 165736){
                    countryCode = "LA";
                }

                if(jQuery('select[name=country]').val() == 165684){
                    countryCode = "LV";
                }

                if(jQuery('select[name=country]').val() == 165718){
                    countryCode = "LB";
                }

                if(jQuery('select[name=country]').val() == 165767){
                    countryCode = "LS";
                }

                if(jQuery('select[name=country]').val() == 162606){
                    countryCode = "LR";
                }

                if(jQuery('select[name=country]').val() == 165759){
                    countryCode = "LY";
                }

                if(jQuery('select[name=country]').val() == 165690){
                    countryCode = "LI";
                }

                if(jQuery('select[name=country]').val() == 165685){
                    countryCode = "LT";
                }

                if(jQuery('select[name=country]').val() == 165693){
                    countryCode = "LU";
                }

                if(jQuery('select[name=country]').val() == 165664){
                    countryCode = "MK";
                }

                if(jQuery('select[name=country]').val() == 165640){
                    countryCode = "MG";
                }

                if(jQuery('select[name=country]').val() == 165771){
                    countryCode = "MW";
                }

                if(jQuery('select[name=country]').val() == 165737){
                    countryCode = "MY";
                }

                if(jQuery('select[name=country]').val() == 165664){
                    countryCode = "MV";
                }

                if(jQuery('select[name=country]').val() == 165785){
                    countryCode = "ML";
                }

                if(jQuery('select[name=country]').val() == 165692){
                    countryCode = "MT";
                }

                if(jQuery('select[name=country]').val() == 165786){
                    countryCode = "MR";
                }

                if(jQuery('select[name=country]').val() == 165772){
                    countryCode = "MU";
                }

                if(jQuery('select[name=country]').val() == 165819){
                    countryCode = "MX";
                }

                if(jQuery('select[name=country]').val() == 165694){
                    countryCode = "MC";
                }

                if(jQuery('select[name=country]').val() == 165727){
                    countryCode = "MN";
                }

                if(jQuery('select[name=country]').val() == 165760){
                    countryCode = "MA";
                }

                if(jQuery('select[name=country]').val() == 165773){
                    countryCode = "MZ";
                }

                if(jQuery('select[name=country]').val() == 165732){
                    countryCode = "MM";
                }

                if(jQuery('select[name=country]').val() == 165775){
                    countryCode = "NA";
                }

                if(jQuery('select[name=country]').val() == 165710){
                    countryCode = "NP";
                }

                if(jQuery('select[name=country]').val() == 165695){
                    countryCode = "NL";
                }

                if(jQuery('select[name=country]').val() == 165743){
                    countryCode = "NZ";
                }

                if(jQuery('select[name=country]').val() == 165816){
                    countryCode = "NI";
                }

                if(jQuery('select[name=country]').val() == 162609){
                    countryCode = "NE";
                }

                if(jQuery('select[name=country]').val() == 162609){
                    countryCode = "NG";
                }

                if(jQuery('select[name=country]').val() == 165696){
                    countryCode = "NO";
                }

                if(jQuery('select[name=country]').val() == 165719){
                    countryCode = "OM";
                }

                if(jQuery('select[name=country]').val() == 165711){
                    countryCode = "PK";
                }

                if(jQuery('select[name=country]').val() == 165817){
                    countryCode = "PA";
                }

                if(jQuery('select[name=country]').val() == 165828){
                    countryCode = "PY";
                }

                if(jQuery('select[name=country]').val() == 165829){
                    countryCode = "PE";
                }

                if(jQuery('select[name=country]').val() == 165738){
                    countryCode = "PH";
                }

                if(jQuery('select[name=country]').val() == 165670){
                    countryCode = "PL";
                }

                if(jQuery('select[name=country]').val() == 165697){
                    countryCode = "PT";
                }

                if(jQuery('select[name=country]').val() == 165806){
                    countryCode = "PR";
                }

                if(jQuery('select[name=country]').val() == 165721){
                    countryCode = "QA";
                }

                if(jQuery('select[name=country]').val() == 165686){
                    countryCode = "RO";
                }

                if(jQuery('select[name=country]').val() == 165687){
                    countryCode = "RU";
                }

                if(jQuery('select[name=country]').val() == 165752){
                    countryCode = "RW";
                }

                if(jQuery('select[name=country]').val() == 165701){
                    countryCode = "SM";
                }

                if(jQuery('select[name=country]').val() == 165787){
                    countryCode = "ST";
                }

                if(jQuery('select[name=country]').val() == 165722){
                    countryCode = "SA";
                }

                if(jQuery('select[name=country]').val() == 162610){
                    countryCode = "SN";
                }

                if(jQuery('select[name=country]').val() == 166072){
                    countryCode = "RS";
                }

                if(jQuery('select[name=country]').val() == 165756){
                    countryCode = "SC";
                }

                if(jQuery('select[name=country]').val() == 162608){
                    countryCode = "SL";
                }

                if(jQuery('select[name=country]').val() == 165739){
                    countryCode = "SG";
                }

                if(jQuery('select[name=country]').val() == 165671){
                    countryCode = "SK";
                }

                if(jQuery('select[name=country]').val() == 165672){
                    countryCode = "SI";
                }

                if(jQuery('select[name=country]').val() == 165753){
                    countryCode = "SO";
                }

                if(jQuery('select[name=country]').val() == 165770){
                    countryCode = "ZA";
                }

                if(jQuery('select[name=country]').val() == 165765){
                    countryCode = "SS";
                }

                if(jQuery('select[name=country]').val() == 165699){
                    countryCode = "ES";
                }

                if(jQuery('select[name=country]').val() == 165712){
                    countryCode = "LK";
                }

                if(jQuery('select[name=country]').val() == 165764){
                    countryCode = "SD";
                }

                if(jQuery('select[name=country]').val() == 165830){
                    countryCode = "SR";
                }

                if(jQuery('select[name=country]').val() == 165768){
                    countryCode = "SZ";
                }

                if(jQuery('select[name=country]').val() == 165700){
                    countryCode = "SE";
                }

                if(jQuery('select[name=country]').val() == 165673){
                    countryCode = "CH";
                }

                if(jQuery('select[name=country]').val() == 165723){
                    countryCode = "SY";
                }

                if(jQuery('select[name=country]').val() == 165702){
                    countryCode = "TW";
                }

                if(jQuery('select[name=country]').val() == 165728){
                    countryCode = "TJ";
                }

                if(jQuery('select[name=country]').val() == 165740){
                    countryCode = "TH";
                }

                if(jQuery('select[name=country]').val() == 165734){
                    countryCode = "TL";
                }

                if(jQuery('select[name=country]').val() == 165791){
                    countryCode = "TG";
                }

                if(jQuery('select[name=country]').val() == 165810){
                    countryCode = "TT";
                }

                if(jQuery('select[name=country]').val() == 165761){
                    countryCode = "TN";
                }

                if(jQuery('select[name=country]').val() == 165688){
                    countryCode = "TR";
                }

                if(jQuery('select[name=country]').val() == 165729){
                    countryCode = "TM";
                }

                if(jQuery('select[name=country]').val() == 165689){
                    countryCode = "UA";
                }

                if(jQuery('select[name=country]').val() == 165724){
                    countryCode = "AE";
                }

                if(jQuery('select[name=country]').val() == 165922){
                    countryCode = "GB";
                }

                if(jQuery('select[name=country]').val() == 165820){
                    countryCode = "US";
                }

                if(jQuery('select[name=country]').val() == 165831){
                    countryCode = "UY";
                }

                if(jQuery('select[name=country]').val() == 165730){
                    countryCode = "UZ";
                }

                if(jQuery('select[name=country]').val() == 165832){
                    countryCode = "VE";
                }

                if(jQuery('select[name=country]').val() == 165741){
                    countryCode = "VN";
                }

                if(jQuery('select[name=country]').val() == 165720){
                    countryCode = "YE";
                }

                if(jQuery('select[name=country]').val() == 165754){
                    countryCode = "ZM";
                }

                if(jQuery('select[name=country]').val() == 165769){
                    countryCode = "ZW";
                }








            }else{
                jQuery("#post-msgBox").text("Please enter country to successfully post to CR");
                jQuery("#post-msgBox").show();
                jQuery("#country-msgBox").show();
            }
            //County Code status:
            var countyCode;
            if(jQuery('select[name="personAddress.countyDistrict"]').val() !=""){
                jQuery("#county-msgBox").hide();
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Nairobi"){
                    countyCode = "047";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Mombasa"){
                    countyCode = "001";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Kwale"){
                    countyCode = "002";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Kilifi"){
                    countyCode = "003";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Tana River"){
                    countyCode = "004";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Lamu"){
                    countyCode = "005";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Taita Taveta"){
                    countyCode = "006";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Garissa"){
                    countyCode = "007";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Wajir"){
                    countyCode = "008";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Mandera"){
                    countyCode = "009";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Marsabit"){
                    countyCode = "010";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Isiolo"){
                    countyCode = "011";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Meru"){
                    countyCode = "012";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Tharaka Nithi"){
                    countyCode = "013";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Embu"){
                    countyCode = "014";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Kitui"){
                    countyCode = "015";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Machakos"){
                    countyCode = "016";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Makueni"){
                    countyCode = "017";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Nyandarua"){
                    countyCode = "018";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Nyeri"){
                    countyCode = "019";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Kirinyaga"){
                    countyCode = "020";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Muranga"){
                    countyCode = "021";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Kiambu"){
                    countyCode = "022";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Turkana"){
                    countyCode = "023";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "West Pokot"){
                    countyCode = "024";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Samburu"){
                    countyCode = "025";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Trans Nzoia"){
                    countyCode = "026";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Uasin Gishu"){
                    countyCode = "027";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Elgeyo Marakwet"){
                    countyCode = "028";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Nandi"){
                    countyCode = "029";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Baringo"){
                    countyCode = "030";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Laikipia"){
                    countyCode = "031";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Nakuru"){
                    countyCode = "032";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Narok"){
                    countyCode = "033";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Kajiado"){
                    countyCode = "034";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Kericho"){
                    countyCode = "035";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Bomet"){
                    countyCode = "036";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Kakamega"){
                    countyCode = "037";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Vihiga"){
                    countyCode = "038";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Bungoma"){
                    countyCode = "039";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Busia"){
                    countyCode = "040";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Siaya"){
                    countyCode = "041";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Kisumu"){
                    countyCode = "042";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Homa Bay"){
                    countyCode = "043";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Migori"){
                    countyCode = "044";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Kisii"){
                    countyCode = "045";
                }
                if(jQuery('select[name="personAddress.countyDistrict"]').val() == "Nyamira"){
                    countyCode = "046";
                }
            }else{
                jQuery("#post-msgBox").text("Please enter county to successfully post to CR");
                jQuery("#post-msgBox").show();
                jQuery("#county-msgBox").show();
            }
            //SubCounty Validation
            if(jQuery('select[name="personAddress.stateProvince"]').val() ==""){
                jQuery("#post-msgBox").text("Please enter sub county to successfully post to CR");
                jQuery("#post-msgBox").show();
                jQuery("#subCounty-msgBox").show();
            }else{
                jQuery("#subCounty-msgBox").hide();
            }
            //Ward Validation
            if(jQuery('select[name="personAddress.address4"]').val() ==""){
                jQuery("#post-msgBox").text("Please enter ward to successfully post to CR");
                jQuery("#post-msgBox").show();
                jQuery("#ward-msgBox").show();
            }else{
                jQuery("#ward-msgBox").hide();
            }
            //Telephone Validation
            if(jQuery('input[name="telephoneContact"]').val() ==""){
                jQuery("#post-msgBox").text("Please enter telephone number to successfully post to CR");
                jQuery("#post-msgBox").show();
                jQuery("#phone-msgBox").show();
            }else{
                jQuery("#phone-msgBox").hide();
            }
            //Age Validation
            if(jQuery('#patient-birthdate_date').val() ==""){
                jQuery("#post-msgBox").text("Please enter age to successfully post to CR");
                jQuery("#post-msgBox").show();
                jQuery("#age-msgBox").show();
            }else{
                jQuery("#age-msgBox").hide();
            }
            //First name Validation
            if(jQuery('input[name="personName.givenName"]').val() ==""){
                jQuery("#post-msgBox").text("Please enter First name to successfully post to CR");
                jQuery("#post-msgBox").show();
                jQuery('#firstname-msgBox').show();
            }else{
                jQuery('#firstname-msgBox').hide();
            }
            //Surname Validation
            if(jQuery('input[name="personName.familyName"]').val() ==""){
                jQuery("#post-msgBox").text("Please enter Surname to successfully post to CR");
                jQuery("#post-msgBox").show();
                jQuery('#surname-msgBox').show();
            }else{
                jQuery('#surname-msgBox').hide();
            }
            //Default mfl code
            var defaultMflCode= '${defaultMflCode}';
            postRegistrationDetailsToCR(
                jQuery('input[name="personName.givenName"]').val(),
                jQuery('input[name="personName.middleName"]').val(),
                jQuery('input[name="personName.familyName"]').val(),
                jQuery('#patient-birthdate_date').val(),
                gender,
                maritalStatus,
                occupationStatus,
                "",   //  Religeon we do not collect
                educationStatus,
                countryCode,
                defaultMflCode,
                "",   //CountyOfBirth variable not collected
                countyCode,
                jQuery('select[name="personAddress.stateProvince"]').val(),
                jQuery('select[name="personAddress.address4"]').val(),
                jQuery('input[name="personAddress.cityVillage"]').val(),
                jQuery('input[name="personAddress.address2"]').val(),    //landmark
                jQuery('input[name="personAddress.address1"]').val(),   //address
                identifierType,
                identifierValue,
                jQuery('input[name="telephoneContact"]').val(),
                jQuery('input[name="alternatePhoneContact"]').val(),
                jQuery('input[name="emailAddress"]').val(),
                jQuery('input[name="nameOfNextOfKin"]').val(),
                jQuery('input[name="nextOfKinRelationship"]').val(),
                "", //Next of kin residence not collected
                jQuery('input[name="nextOfKinContact"]').val(),
                "", //Next of kin secondary phone not collected
                "", //Next of kin email address not collected
                jQuery('input[name="dead"]').val()

            ) });


        //On Edit prepopulate patient Identifiers
        var savedAge = jQuery('#patient-birthdate').val();
        var patientAge = Math.floor((new Date() - new Date(savedAge)) / 1000 / 60 / 60 / 24 / 365.25);
        if(savedAge !="") {
            jQuery('#identifiers').show();
            // Validate identifiers according to age
            // Hide Natioanl ID for less than 18 years old
            if(patientAge > 17){
                jQuery('#national-id').show();
                jQuery('#driving-license').show();
            }else{
               jQuery('#national-id').hide();
               jQuery('#driving-license').hide();
            }
        }

        if("${isKDoD}"=="false"){
            jQuery('#kdod-struct').hide();
            jQuery('#kdod-service-no').hide();
        }
        else {
            jQuery('#kdod-struct').show();
            jQuery('#kdod-service-no').show();

            jq("select[name='kDoDCadre']").change(function () {
                var cadre = jq(this).val();

                if (cadre === "Civilian") {
                    jq('#rank').hide();
                    jq('#unit').hide();

                    jq(".kDoDUnit").val("");

                    jq(".kDoDRank")[0].selectedIndex = 0;

                    jq('.kDoDRank').removeAttr('required');
                    jq('.kDoDUnit').removeAttr('required');

                    jq('.kDoDRank').hide();
                    jq('.kDoDUnit').hide();

                }
                else {
                    jq('.kDoDRank').attr('required',1);
                    jq('.kDoDUnit').attr('required',1);

                    jq('#rank').show();
                    jq('#unit').show();

                    jq('.kDoDRank').show();
                    jq('.kDoDUnit').show();

                }
            });
        }

        jQuery('#county').change(updateSubcounty);
        jQuery('#subCounty').change(updateWard);
        jQuery('#patient-birthdate_date').change(updateIdentifiers);

        jQuery('#from-age-button').appendTo(jQuery('#from-age-button-placeholder'));
        jQuery('#edit-patient-form .cancel-button').click(function () {
            ui.navigate('${ config.returnUrl }');
        });
        kenyaui.setupAjaxPost('edit-patient-form', {
            onSuccess: function (data) {
                if (data.id) {
                    <% if (config.returnUrl) { %>
                    ui.navigate('${ config.returnUrl }');
                    <% } else { %>
                    ui.navigate('kenyaemr', 'registration/registrationViewPatient', {patientId: data.id});
                    <% } %>
                } else {
                    kenyaui.notifyError('Saving patient was successful, but unexpected response');
                }
            }
        });
        updateSubcountyOnEdit();
        updateWardOnEdit();

    }); // end of jQuery initialization block

    function updateBirthdate(data) {
        var birthdate = new Date(data.birthdate);
        kenyaui.setDateField('patient-birthdate', birthdate);
        kenyaui.setRadioField('patient-birthdate-estimated', 'true');
        jQuery('#identifiers').show();
        // Validate identifiers according to age
        // Hide Natioanl ID for less than 18 years old
        if(birthdate !="") {
            var age = Math.floor((new Date() - new Date(birthdate)) / 1000 / 60 / 60 / 24 / 365.25);
            if (age > 17) {
                jQuery('#national-id').show();
                jQuery('#driving-license').show();
            } else {
                jQuery('#national-id').hide();
                jQuery('#driving-license').hide();
            }
        }
    }
    function updateSubcounty() {

        jQuery('#subCounty').empty();
        jQuery('#ward').empty();
        var selectedCounty = jQuery('#county').val();
        var scKey;
        jQuery('#subCounty').append(jQuery("<option></option>").attr("value", "").text(""));
        for (scKey in kenyaAddressHierarchy[selectedCounty]) {
            jQuery('#subCounty').append(jQuery("<option></option>").attr("value", scKey).text(scKey));

        }
    }

    function updateSubcountyOnEdit() {

        jQuery('#subCounty').empty();
        jQuery('#ward').empty();
        var selectedCounty = jQuery('#county').val();
        var scKey;
        jQuery('#subCounty').append(jQuery("<option></option>").attr("value", "").text(""));
        for (scKey in kenyaAddressHierarchy[selectedCounty]) {

            jQuery('#subCounty').append(jQuery("<option></option>").attr("value", scKey).text(scKey));

        }
        jQuery('#subCounty').val('${subCounty}');
    }

    function updateWardOnEdit() {

        jQuery('#ward').empty();
        var selectedCounty = jQuery('#county').val();
        var selectedsubCounty = jQuery('#subCounty').val();
        var scKey;
        jQuery('#ward').append(jQuery("<option></option>").attr("value", "").text(""));
        for (scKey in kenyaAddressHierarchy[selectedCounty][selectedsubCounty]) {
            jQuery('#ward').append(jQuery("<option></option>").attr("value", kenyaAddressHierarchy[selectedCounty][selectedsubCounty][scKey].facility).text(kenyaAddressHierarchy[selectedCounty][selectedsubCounty][scKey].facility));

        }
        jQuery('#ward').val('${ward}');
    }

    function updateWard() {

        jQuery('#ward').empty();
        var selectedCounty = jQuery('#county').val();
        var selectedsubCounty = jQuery('#subCounty').val();
        var scKey;
        jQuery('#ward').append(jQuery("<option></option>").attr("value", "").text(""));
        for (scKey in kenyaAddressHierarchy[selectedCounty][selectedsubCounty]) {
            jQuery('#ward').append(jQuery("<option></option>").attr("value", kenyaAddressHierarchy[selectedCounty][selectedsubCounty][scKey].facility).text(kenyaAddressHierarchy[selectedCounty][selectedsubCounty][scKey].facility));

        }
    }
    function updateIdentifiers() {
        var selectedDob = jQuery('#patient-birthdate').val();
        if(selectedDob !="") {
            jQuery('#identifiers').show();
            // Validate identifiers according to age
            // Hide Natioanl ID for less than 18 years old
            var age = Math.floor((new Date() - new Date(selectedDob)) / 1000 / 60 / 60 / 24 / 365.25);
            if(age > 17){
                jQuery('#national-id').show();
            }else{
                jQuery('#national-id').hide();
            }
        }
    }
    //Ckeckbox to populate the other identifiers
    var otherIdentifiersChange = function () {

        var val = jq(this).val();
        var selectedDob = jQuery('#patient-birthdate').val();
        if (jq(this).is(':checked')){
            jQuery('#alien-no').show();
            jQuery('#huduma-no').show();
            jQuery('#passport-no').show();
            jQuery('#birth-cert-no').show();
            jQuery('#driving-license').show();
        }else{
            jQuery('#alien-no').hide();
            jQuery('#huduma-no').hide();
            jQuery('#passport-no').hide();
            jQuery('#driving-license').hide();
        }
    }

    //Ckeckbox to select country Kenya
    var selectCountryKenyaOption = function () {
        var val = jq(this).val();
        if (jq(this).is(':checked')){
            jQuery('select[name=country]').val(162883);
        }else{
            jQuery('select[name=country]').val("");
        }

        jQuery('select[name=country]').on('change', function() {
         if(this.value != 162883)  {
             jq("#select-kenya-option").prop("checked", false);
         }
         });
    }

    function showDataFromCR() {
        kenyaui.openPanelDialog({ templateId: 'cr-dialog', width: 55, height: 80, scrolling: true });
    }

    function useDemographics(){
        useFullName();
        useContact('telephoneContact','primaryPhone');
        useContact('alternatePhoneContact','secondaryPhone');
        useContact('emailAddress','emailAddress');
    }
    // re-use name from client registry
    function useFullName(){
        if (crResponseData.client.firstName != '') {
            jQuery('input[name="personName.givenName"]').val(crResponseData.client.firstName);
        }

        if (crResponseData.client.middleName != '') {
            jQuery('input[name="personName.middleName"]').val(crResponseData.client.middleName);
        }

        if (crResponseData.client.lastName != '') {
            jQuery('input[name="personName.familyName"]').val(crResponseData.client.lastName);
        }

    }

    // uses crResponseData.client as base. Doesn't work for nested objects
    function updateClientVariable(formInputName, responseVariablePath) {
        if (crResponseData.client[responseVariablePath] != '') {
            jQuery("input[name='" + formInputName +"']").val(crResponseData.client[responseVariablePath]);
        }
    }

    // use client.contact as base
    function useContact(formInputName, responseVariablePath){
        if (crResponseData.client.contact[responseVariablePath] != '') {
            jQuery("input[name='" + formInputName +"']").val(crResponseData.client.contact[responseVariablePath]);
        }

    }



    // use client.identifications as base
    function useIdentifiers(){

        if (crResponseData.client.identifications.length > 0) {
            var nationalIdType = 'Identification Number';
            var passportIdType = 'passport-no';
            var birthCertificateIdType = 'birth-certificate';

            for (i = 0; i < crResponseData.client.identifications.length; i++) {
                var identifierObj = crResponseData.client.identifications[i];
                if (identifierObj.identificationType == nationalIdType) {
                    jQuery("input[name='nationalIdNumber']").val(identifierObj.identificationNumber);
                } else if (identifierObj.identificationType == passportIdType) {
                    jQuery("input[name='passPortNumber']").val(identifierObj.identificationNumber);
                } else if (identifierObj.identificationType == birthCertificateIdType) {
                    jQuery("input[name='birthCertificateNumber']").val(identifierObj.identificationNumber);
                }
            }

            // update NUPI
            jQuery("input[name='nationalUniquePatientNumber']").val(crResponseData.client.clientNumber);

        }

    }

    // use client.nextOfKins as base
    function useNextofKin(){

        var firstNok = crResponseData.client.nextOfKins[0];

        if (firstNok.name != '') {
            jQuery('input[name="nameOfNextOfKin"]').val(firstNok.name);
        }

        if (firstNok.contact.primaryPhone != '') {
            jQuery('input[name="nextOfKinContact"]').val(firstNok.contact.primaryPhone);
        }

        if (firstNok.residence != '') {
            jQuery('input[name="nextOfKinAddress"]').val(firstNok.residence);
        }

    }

    //var loadingImageURL = ui.resourceLink("kenyaemr", "images/loading.gif");
    //var showLoadingImage = '<span style="padding:2px; display:inline-block;"> <img src="' + loadingImageURL + '" /> </span>';

    function display_loading_post_registration(status) {
        if(status) {
            jq('.wait-loading-post-registration').empty();
            jq('.wait-loading-post-registration').append(showLoadingImage);
        } else {
            jq('.wait-loading-post-registration').empty();
        }
    }

    function postRegistrationDetailsToCR(firstName,middleName,lastName,dateOfBirth,gender,maritalStatus,occupationStatus,religion,educationStatus,countryCode,defaultMflCode,countyOfBirth,countyCode,subCounty,ward,village,landMark,address,identificationType,identificationValue,primaryPhone,secondaryPhone,emailAddress,name,relationship,residence,nokPrimaryPhone,nokSecondaryPhone,nokEmailAddress,isAlive) {
        // connect to CR server and post data

        // Show spinner
        display_loading_post_registration(true);

        var params = params

        var params = {
            "firstName": firstName,
            "middleName": middleName,
            "lastName": lastName,
            "dateOfBirth": dateOfBirth,
            "maritalStatus": maritalStatus,
            "gender": gender,
            "occupation": occupationStatus,
            "religion": "",
            "educationLevel": educationStatus,
            "country": countryCode,
            "countyOfBirth": countyCode,
            "isAlive": true,
            "originFacilityKmflCode": defaultMflCode,
            "residence": {
                "county": countyCode,
                "subCounty": subCounty.toLowerCase().replace(" ", '-'),
                "ward": ward.toLowerCase().replace(" ", '-'),
                "village": village,
                "landMark": landMark,
                "address": address
            },
            "identifications": [{
                "identificationType": identificationType,
                "identificationNumber": identificationValue
            }],
            "contact": {
                "primaryPhone": primaryPhone,
                "secondaryPhone": secondaryPhone,
                "emailAddress": emailAddress
            },
            "nextOfKins": []
        }


        //Using fragment action to post
        jQuery.getJSON('${ ui.actionLink("kenyaemr", "upi/upiDataExchange", "postUpiClientRegistrationInfoToCR")}',
            {
                'postParams': JSON.stringify(params)
            })
            .success(function (data) {
                // Hide spinner
                display_loading_post_registration(false);

                if(data.clientNumber){
                    jQuery("input[name='nationalUniquePatientNumber']").val(data.clientNumber);
                    jQuery("#post-msgBox").text("Assigned National UPI : " + data.clientNumber);
                    jQuery("input[name='CRVerificationStatus']").val("Yes").attr('readonly', true);
                    jQuery("#post-msgBox").show();

                }else if(jQuery("input[name='nationalUniquePatientNumber']").val() !="" ){
                    jQuery("#post-msgBox").text(jQuery("input[name='nationalUniquePatientNumber']").val());
                    jQuery("input[name='CRVerificationStatus']").val("Verified").attr('readonly', true);
                    jQuery("#post-msgBox").show();
                }else if(jQuery("input[name='nationalUniquePatientNumber']").val() =="" ){
                    //jQuery("#post-msgBox").text("");
                    jQuery("input[name='CRVerificationStatus']").val("Pending").attr('readonly', true);
                   // jQuery("#post-msgBox").hide();
                }
            })
            .fail(function (err) {
                    // Hide spinner
                    display_loading_post_registration(false);

                    console.log(err)
                    jQuery("input[name='CRVerificationStatus']").val("Pending");
                    jQuery("#post-msgBox").text("Could not verify with Client registry. Please continue with registration");
                    jQuery("#post-msgBox").show();
                }
            )
    }


</script>

