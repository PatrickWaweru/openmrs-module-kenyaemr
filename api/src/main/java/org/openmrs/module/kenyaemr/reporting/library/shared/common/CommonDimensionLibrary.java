/**
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/. OpenMRS is also distributed under
 * the terms of the Healthcare Disclaimer located at http://openmrs.org/license.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */
package org.openmrs.module.kenyaemr.reporting.library.shared.common;

import org.openmrs.module.kenyaemr.reporting.MohReportUtils.ReportingUtils;
import org.openmrs.module.reporting.evaluation.parameter.Parameter;
import org.openmrs.module.reporting.indicator.dimension.CohortDefinitionDimension;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Date;

import static org.openmrs.module.kenyacore.report.ReportUtils.map;

/**
 * Library of common dimension definitions
 */
@Component
public class CommonDimensionLibrary {


    private final CommonCohortLibrary commonCohortLibrary;
    @Autowired
    public CommonDimensionLibrary(CommonCohortLibrary commonCohortLibrary) {
        this.commonCohortLibrary = commonCohortLibrary;
    }

    /**
     * Gender dimension
     * @return the dimension
     */
    public CohortDefinitionDimension gender() {
        CohortDefinitionDimension dim = new CohortDefinitionDimension();
        dim.setName("gender");
        dim.addCohortDefinition("M", map(commonCohortLibrary.males()));
        dim.addCohortDefinition("F", map(commonCohortLibrary.females()));
        return dim;
    }

    /**
     * Dimension of age using the 3 standard age groups
     * @return the dimension
     */
    public CohortDefinitionDimension standardAgeGroups() {
        CohortDefinitionDimension dim = new CohortDefinitionDimension();
        dim.setName("age groups (<1, <15, 15+, <5, 5+,5-59, 60+)");
        dim.addParameter(new Parameter("onDate", "Date", Date.class));
        dim.addCohortDefinition("<1", map(commonCohortLibrary.agedAtMost(0), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("<15", map(commonCohortLibrary.agedAtMost(14), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("15+", map(commonCohortLibrary.agedAtLeast(15), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("<5", map(commonCohortLibrary.agedAtMost(4), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("5+", map(commonCohortLibrary.agedAtLeast(5), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("60+", map(commonCohortLibrary.agedAtLeast(60), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("5-59", map(commonCohortLibrary.agedAtLeastAgedAtMost(5, 59), "effectiveDate=${onDate}"));
        return dim;
    }

    /**
     * Dimension of age between
     * @return Dimension
     */
    public CohortDefinitionDimension artRegisterAgeGroups() {
        CohortDefinitionDimension dim = new CohortDefinitionDimension();

        dim.setName("fine age between(<9, btw 10 and 19, 25+");
        dim.addParameter(new Parameter("onDate", "Date", Date.class));
        dim.addCohortDefinition("<9", map(commonCohortLibrary.agedAtMost(0), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("9-19", map(commonCohortLibrary.agedAtLeastAgedAtMost(9, 19), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("20+", map(commonCohortLibrary.agedAtLeast(20), "effectiveDate=${onDate}"));
         return dim;
    }

    /**
     * Dimension of age between
     * @return Dimension
     */
    public CohortDefinitionDimension datimFineAgeGroups() {
        CohortDefinitionDimension dim = new CohortDefinitionDimension();
        dim.setName("fine age between(<1, btw 1 and 9, btw 10 and 14, btw 15 and 19, btw 20 and 24, btw 25 and 49, 50+");
        dim.addParameter(new Parameter("onDate", "Date", Date.class));
        dim.addCohortDefinition("<1", map(commonCohortLibrary.agedAtMost(0), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("<10", map(commonCohortLibrary.agedAtMost(9), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("0-9", map(commonCohortLibrary.agedAtLeastAgedAtMost(0, 9), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("1-4", map(commonCohortLibrary.agedAtLeastAgedAtMost(1, 4), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("5-9", map(commonCohortLibrary.agedAtLeastAgedAtMost(5, 9), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("1-9", map(commonCohortLibrary.agedAtLeastAgedAtMost(1, 9), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("10-14", map(commonCohortLibrary.agedAtLeastAgedAtMost(10, 14), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("10-17", map(commonCohortLibrary.agedAtLeastAgedAtMost(10, 17), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("10-19", map(commonCohortLibrary.agedAtLeastAgedAtMost(10, 19), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("15-19", map(commonCohortLibrary.agedAtLeastAgedAtMost(15, 19), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("18-49", map(commonCohortLibrary.agedAtLeastAgedAtMost(18, 49), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("20-24", map(commonCohortLibrary.agedAtLeastAgedAtMost(20, 24), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("25-49", map(commonCohortLibrary.agedAtLeastAgedAtMost(25, 49), "effectiveDate=${onDate}"));
        // new age disaggregations
        dim.addCohortDefinition("25-29", map(commonCohortLibrary.agedAtLeastAgedAtMost(25, 29), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("30-34", map(commonCohortLibrary.agedAtLeastAgedAtMost(30, 34), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("35-39", map(commonCohortLibrary.agedAtLeastAgedAtMost(35, 39), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("40-44", map(commonCohortLibrary.agedAtLeastAgedAtMost(40, 44), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("45-49", map(commonCohortLibrary.agedAtLeastAgedAtMost(45, 49), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("40-49", map(commonCohortLibrary.agedAtLeastAgedAtMost(40, 49), "effectiveDate=${onDate}"));
        // previous one
        dim.addCohortDefinition("50+", map(commonCohortLibrary.agedAtLeast(50), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("25+", map(commonCohortLibrary.agedAtLeast(25), "effectiveDate=${onDate}"));
        //mer2.6
        dim.addCohortDefinition("50-54", map(commonCohortLibrary.agedAtLeastAgedAtMost(50, 54), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("55-59", map(commonCohortLibrary.agedAtLeastAgedAtMost(55, 59), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("60-64", map(commonCohortLibrary.agedAtLeastAgedAtMost(60, 64), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("65+", map(commonCohortLibrary.agedAtLeast(65), "effectiveDate=${onDate}"));
        //Age group in months
        dim.addCohortDefinition("0-2", map(commonCohortLibrary.agedAtLeastAgedAtMostInMonths(0, 2), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("2-12", map(commonCohortLibrary.agedAtLeastAgedAtMostInMonths(2, 12), "effectiveDate=${onDate}"));

        dim.addCohortDefinition("<15", map(commonCohortLibrary.agedAtMost(14), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("15+", map(commonCohortLibrary.agedAtLeast(15), "effectiveDate=${onDate}"));
        //Age group in days
        dim.addCohortDefinition("0-60", map(commonCohortLibrary.agedAtLeastAgedAtMostDays(0, 60),"effectiveDate=${onDate}"));
        //fmaps
        dim.addCohortDefinition("0-12", map(commonCohortLibrary.agedAtLeastAgedAtMostDays(1, 12),"effectiveDate=${onDate}"));
        dim.addCohortDefinition("12-24", map(commonCohortLibrary.agedAtLeastAgedAtMostWeeks(12, 24),"effectiveDate=${onDate}"));
        dim.addCohortDefinition("7-9", map(commonCohortLibrary.agedAtLeastAgedAtMostInMonths(7, 9),"effectiveDate=${onDate}"));
        dim.addCohortDefinition("10-12", map(commonCohortLibrary.agedAtLeastAgedAtMostInMonths(10, 12),"effectiveDate=${onDate}"));
        dim.addCohortDefinition("1+", map(commonCohortLibrary.agedAtLeast(1),"effectiveDate=${onDate}"));

        return dim;
    }

    /**
     * Dimension of age between
     * @return Dimension
     */
    public CohortDefinitionDimension moh731GreenCardAgeGroups() {
        CohortDefinitionDimension dim = new CohortDefinitionDimension();
        dim.setName("fine age between(<1, btw 1 and 9, btw 10 and 14, btw 15 and 19, btw 20 and 24, 25+");
        dim.addParameter(new Parameter("onDate", "Date", Date.class));
        dim.addCohortDefinition("<1", map(commonCohortLibrary.agedAtMost(0), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("0-60", map(commonCohortLibrary.agedAtLeastAgedAtMostDays(0,60), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("61-9", map(commonCohortLibrary.agedAtLeastDaysAgedAtMostYears(61,9), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("0-4", map(commonCohortLibrary.agedAtLeastAgedAtMost(0, 4), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("1-4", map(commonCohortLibrary.agedAtLeastAgedAtMost(1, 4), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("1-9", map(commonCohortLibrary.agedAtLeastAgedAtMost(1, 9), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("0-9", map(commonCohortLibrary.agedAtLeastAgedAtMost(0, 9), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("2-9", map(commonCohortLibrary.agedAtLeastAgedAtMost(2, 9), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("5-9", map(commonCohortLibrary.agedAtLeastAgedAtMost(5, 9), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("0-14", map(commonCohortLibrary.agedAtMost(14), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("<15", map(commonCohortLibrary.agedAtMost(14), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("15+", map(commonCohortLibrary.agedAtLeast(15), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("10-14", map(commonCohortLibrary.agedAtLeastAgedAtMost(10, 14), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("15-19", map(commonCohortLibrary.agedAtLeastAgedAtMost(15, 19), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("10-19", map(commonCohortLibrary.agedAtLeastAgedAtMost(10, 19), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("20-24", map(commonCohortLibrary.agedAtLeastAgedAtMost(20, 24), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("25-29", map(commonCohortLibrary.agedAtLeastAgedAtMost(25, 29), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("20+", map(commonCohortLibrary.agedAtLeast(20), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("25+", map(commonCohortLibrary.agedAtLeast(25), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("30+", map(commonCohortLibrary.agedAtLeast(30), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("18+", map(commonCohortLibrary.agedAtLeast(18), "effectiveDate=${onDate}"));
        //25-49 and 50+ added for KDoD
        dim.addCohortDefinition("25-49", map(commonCohortLibrary.agedAtLeastAgedAtMost(25, 49), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("50+", map(commonCohortLibrary.agedAtLeast(50), "effectiveDate=${onDate}"));

        return dim;
    }

    /**
     * Dimension of age between
     * @return Dimension
     */
    public CohortDefinitionDimension otzAgeGroups() {
        CohortDefinitionDimension dim = new CohortDefinitionDimension();
        dim.setName("fine age between(<1, btw 1 and 9, btw 10 and 14, btw 15 and 19, btw 20 and 24, 25+");
        dim.addParameter(new Parameter("onDate", "Date", Date.class));
        dim.addCohortDefinition("10-19", map(commonCohortLibrary.agedAtLeastAgedAtMost(10, 19), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("20-24", map(commonCohortLibrary.agedAtLeastAgedAtMost(20, 24), "effectiveDate=${onDate}"));

        return dim;
    }

    public CohortDefinitionDimension specialClinicsAgeGroups() {
        CohortDefinitionDimension dim = new CohortDefinitionDimension();
        dim.setName("fine age between(<1, btw 1 and 12, btw 1 and 5, btw 5 and 9, btw 10 and 14");
        dim.addParameter(new Parameter("onDate", "Date", Date.class));
        dim.addCohortDefinition("<1", map(commonCohortLibrary.agedAtMostDays(29), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("1-12", map(commonCohortLibrary.agedAtLeastAgedAtMostInMonths(1, 12), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("1-5", map(commonCohortLibrary.agedAtLeastAgedAtMost(1, 5), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("5-9", map(commonCohortLibrary.agedAtLeastAgedAtMost(5, 9), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("10-14", map(commonCohortLibrary.agedAtLeastAgedAtMost(10, 14), "effectiveDate=${onDate}"));
        return dim;
    }

    public CohortDefinitionDimension moh740AgeGroups() {
        CohortDefinitionDimension dim = new CohortDefinitionDimension();
        dim.setName("fine age between(<0,>=60");
        dim.addParameter(new Parameter("onDate", "Date", Date.class));
        dim.addCohortDefinition("0-5", map(commonCohortLibrary.agedAtLeastAgedAtMost(0, 5), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("0-18", map(commonCohortLibrary.agedAtLeastAgedAtMost(0, 18), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("6-18", map(commonCohortLibrary.agedAtLeastAgedAtMost(6, 18), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("19-35", map(commonCohortLibrary.agedAtLeastAgedAtMost(19, 35), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("36-60", map(commonCohortLibrary.agedAtLeastAgedAtMost(36, 60), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("36+", map(commonCohortLibrary.agedAtLeast(36), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("60+", map(commonCohortLibrary.agedAtLeast(60), "effectiveDate=${onDate}"));
        return dim;
    }


    /**
     * Dimension of age between
     * @return Dimension
     */
    public CohortDefinitionDimension moh710AgeGroups() {
        CohortDefinitionDimension dim = new CohortDefinitionDimension();
        dim.setName("Fine age between(<1,>=1)");
        dim.addParameter(new Parameter("onDate", "Date", Date.class));
        dim.addCohortDefinition("<1", map(commonCohortLibrary.agedAtMost(0), "effectiveDate=${onDate}"));
        dim.addCohortDefinition(">=1", map(commonCohortLibrary.agedAtLeast(1), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("18-24", map(commonCohortLibrary.agedAtLeastAgedAtMostInMonths(18, 24), "effectiveDate=${onDate}"));
        dim.addCohortDefinition(">2", map(commonCohortLibrary.agedAtLeast(2), "effectiveDate=${onDate}"));
        return dim;
    }

    /**
     * Dimension of age between
     * @return Dimension
     */
    public CohortDefinitionDimension moh745AgeGroups() {
        CohortDefinitionDimension dim = new CohortDefinitionDimension();
        dim.setName("age between(<25,>=50)");
        dim.addParameter(new Parameter("onDate", "Date", Date.class));
        dim.addCohortDefinition("<25", map(commonCohortLibrary.agedAtMost(24), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("25-49", map(commonCohortLibrary.agedAtLeastAgedAtMost(25, 49), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("<35", map(commonCohortLibrary.agedAtMost(34), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("56+", map(commonCohortLibrary.agedAtLeast(56), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("50+", map(commonCohortLibrary.agedAtLeast(50), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("35-55", map(commonCohortLibrary.agedAtLeastAgedAtMost(35, 55), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("<40", map(commonCohortLibrary.agedAtMost(39), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("40-75", map(commonCohortLibrary.agedAtLeastAgedAtMost(40, 75), "effectiveDate=${onDate}"));
        dim.addCohortDefinition(">=50", map(commonCohortLibrary.agedAtLeast(50), "effectiveDate=${onDate}"));

        return dim;
    }

    /**
     * Dimension of age using the 2 standard age groups. <15 and 15+ years
     * @return the dimension
     */
    public CohortDefinitionDimension diffCareAgeGroups() {
        CohortDefinitionDimension dim = new CohortDefinitionDimension();
        dim.setName("age groups (<15, 15+)");
        dim.addParameter(new Parameter("onDate", "Date", Date.class));
        dim.addCohortDefinition("<15", map(commonCohortLibrary.agedAtMost(14), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("15+", map(commonCohortLibrary.agedAtLeast(15), "effectiveDate=${onDate}"));
        return dim;
    }
    /**
     * Cadre dimension
     * @return the dimension
     */
    public CohortDefinitionDimension cadre() {
        CohortDefinitionDimension dim = new CohortDefinitionDimension();
        dim.setName("cadre");
        dim.addCohortDefinition("T", map(commonCohortLibrary.kDoDTroupesPatients()));
        dim.addCohortDefinition("C", map(commonCohortLibrary.kDoDCiviliansPatients()));
        return dim;
    }

    /**
     * Dimension of age using the 2 standard age groups
     * @return the dimension
     */
    public CohortDefinitionDimension contactAgeGroups() {
        CohortDefinitionDimension dim = new CohortDefinitionDimension();
        dim.setName("age groups (<15, 15+)");
        dim.addParameter(new Parameter("onDate", "Date", Date.class));
        dim.addCohortDefinition("<15", map(commonCohortLibrary.contactAgedAtMost(14), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("15+", map(commonCohortLibrary.contactAgedAtLeast(15), "effectiveDate=${onDate}"));

        return dim;
    }

    /**
     * Dimension of age between
     * @return Dimension
     */
    public CohortDefinitionDimension contactsFineAgeGroups() {
        CohortDefinitionDimension dim = new CohortDefinitionDimension();
        dim.setName("fine age between(<1, btw 1 and 4,btw 5 and 9, btw 10 and 14, btw 15 and 19, btw 20 and 24, btw 25 and 29, btw 30 and 34, btw 35 and 39, btw 40 and 44, btw 45 and 49, 50+");
        dim.addParameter(new Parameter("onDate", "Date", Date.class));
        dim.addCohortDefinition("<1", map(commonCohortLibrary.contactAgedAtMost(0), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("1-4", map(commonCohortLibrary.contactAgedAtLeastAgedAtMost(1,4), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("5-9", map(commonCohortLibrary.contactAgedAtLeastAgedAtMost(5,9), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("10-14", map(commonCohortLibrary.contactAgedAtLeastAgedAtMost(10,14), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("15-19", map(commonCohortLibrary.contactAgedAtLeastAgedAtMost(15,19), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("20-24", map(commonCohortLibrary.contactAgedAtLeastAgedAtMost(20,24), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("25-29", map(commonCohortLibrary.contactAgedAtLeastAgedAtMost(25,29), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("30-34", map(commonCohortLibrary.contactAgedAtLeastAgedAtMost(30,34), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("35-39", map(commonCohortLibrary.contactAgedAtLeastAgedAtMost(35,39), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("40-44", map(commonCohortLibrary.contactAgedAtLeastAgedAtMost(40,44), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("45-49", map(commonCohortLibrary.contactAgedAtLeastAgedAtMost(45,49), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("50+", map(commonCohortLibrary.contactAgedAtLeast(50), "effectiveDate=${onDate}"));

        return dim;
    }

    /**
     * Gender dimension for patient contact
     * @return the dimension
     */
    public CohortDefinitionDimension contactGender() {
        CohortDefinitionDimension dim = new CohortDefinitionDimension();
        dim.setName("contactGender");
        dim.addCohortDefinition("M", map(commonCohortLibrary.malePatientContacts()));
        dim.addCohortDefinition("F", map(commonCohortLibrary.femalePatientContacts()));
        return dim;
    }
/**
 * MOH711 Child age dimensions
 */
public CohortDefinitionDimension childAgeGroups() {
    CohortDefinitionDimension dim = new CohortDefinitionDimension();
    dim.setName("age between(0-59 Months)");
    dim.addParameter(new Parameter("onDate", "Date", Date.class));
    dim.addCohortDefinition("0-5", map(commonCohortLibrary.agedAtLeastAgedAtMostInMonths(0, 5), "effectiveDate=${onDate}"));
    dim.addCohortDefinition("6-23", map(commonCohortLibrary.agedAtLeastAgedAtMostInMonths(6, 23), "effectiveDate=${onDate}"));
    dim.addCohortDefinition("24-59", map(commonCohortLibrary.agedAtLeastAgedAtMostInMonths(24, 59), "effectiveDate=${onDate}"));
    dim.addCohortDefinition("6-59", map(commonCohortLibrary.agedAtLeastAgedAtMostInMonths(6, 59), "effectiveDate=${onDate}"));
    dim.addCohortDefinition("0-59", map(commonCohortLibrary.agedAtLeastAgedAtMostInMonths(0, 59), "effectiveDate=${onDate}"));
    dim.addCohortDefinition("12-59", map(commonCohortLibrary.agedAtLeastAgedAtMostInMonths(12, 59), "effectiveDate=${onDate}"));
    return dim;
}
    /**
     * HCA age dimensions
     * @return Dimension
     */
    public CohortDefinitionDimension HcaAgeGroups() {
        CohortDefinitionDimension dim = new CohortDefinitionDimension();
        dim.setName("Fine age between(<1,>=1)");
        dim.addParameter(new Parameter("onDate", "Date", Date.class));
        dim.addCohortDefinition("<1", map(commonCohortLibrary.agedAtMost(0), "effectiveDate=${onDate}"));
        dim.addCohortDefinition(">=1", map(commonCohortLibrary.agedAtLeast(1), "effectiveDate=${onDate}"));
        dim.addCohortDefinition("18-24", map(commonCohortLibrary.agedAtLeastAgedAtMostInMonths(18, 24), "effectiveDate=${onDate}"));
        dim.addCohortDefinition(">2", map(commonCohortLibrary.agedAtLeast(2), "effectiveDate=${onDate}"));
        return dim;
    }

    public CohortDefinitionDimension encountersOfMonthPerDay() {
        CohortDefinitionDimension dim = new CohortDefinitionDimension();
        dim.setName("Patient with encounters on date of day");
        dim.addParameter(new Parameter("startDate", "Start Date", Date.class));
        dim.addParameter(new Parameter("endDate", "End Date", Date.class));
        dim.addCohortDefinition("1", map(commonCohortLibrary.getPatientsSeenOnDay(0), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("2", map(commonCohortLibrary.getPatientsSeenOnDay(1), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("3", map(commonCohortLibrary.getPatientsSeenOnDay(2), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("4", map(commonCohortLibrary.getPatientsSeenOnDay(3), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("5", map(commonCohortLibrary.getPatientsSeenOnDay(4), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("6", map(commonCohortLibrary.getPatientsSeenOnDay(5), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("7", map(commonCohortLibrary.getPatientsSeenOnDay(6), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("8", map(commonCohortLibrary.getPatientsSeenOnDay(7), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("9", map(commonCohortLibrary.getPatientsSeenOnDay(8), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("10", map(commonCohortLibrary.getPatientsSeenOnDay(9), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("11", map(commonCohortLibrary.getPatientsSeenOnDay(10), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("12", map(commonCohortLibrary.getPatientsSeenOnDay(11), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("13", map(commonCohortLibrary.getPatientsSeenOnDay(12), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("14", map(commonCohortLibrary.getPatientsSeenOnDay(13), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("15", map(commonCohortLibrary.getPatientsSeenOnDay(14), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("16", map(commonCohortLibrary.getPatientsSeenOnDay(15), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("17", map(commonCohortLibrary.getPatientsSeenOnDay(16), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("18", map(commonCohortLibrary.getPatientsSeenOnDay(17), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("19", map(commonCohortLibrary.getPatientsSeenOnDay(18), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("20", map(commonCohortLibrary.getPatientsSeenOnDay(19), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("21", map(commonCohortLibrary.getPatientsSeenOnDay(20), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("22", map(commonCohortLibrary.getPatientsSeenOnDay(21), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("23", map(commonCohortLibrary.getPatientsSeenOnDay(22), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("24", map(commonCohortLibrary.getPatientsSeenOnDay(23), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("25", map(commonCohortLibrary.getPatientsSeenOnDay(24), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("26", map(commonCohortLibrary.getPatientsSeenOnDay(25), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("27", map(commonCohortLibrary.getPatientsSeenOnDay(26), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("28", map(commonCohortLibrary.getPatientsSeenOnDay(27), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("29", map(commonCohortLibrary.getPatientsSeenOnDay(28), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("30", map(commonCohortLibrary.getPatientsSeenOnDay(29), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("31", map(commonCohortLibrary.getPatientsSeenOnDay(30), "startDate=${startDate},endDate=${endDate}"));

        return dim;
    }
    public CohortDefinitionDimension newOrRevisits() {
        CohortDefinitionDimension dim = new CohortDefinitionDimension();
        dim.setName("New or revisits patients");
        dim.addParameter(new Parameter("startDate", "After date", Date.class));
        dim.addParameter(new Parameter("endDate", "Before date", Date.class));
        dim.addCohortDefinition("RVT",
                map(ReportingUtils.reAttendances(">=0"), "startDate=${startDate},endDate=${endDate}"));
        dim.addCohortDefinition("NEW",
                map(ReportingUtils.newAttendances(">=0"), "startDate=${startDate},endDate=${endDate}"));
        return dim;
    }
}
