--------------------------------------------------------------------------
-- Drop tables section
--------------------------------------------------------------------------
DROP TABLE CTCA_Location CASCADE CONSTRAINTS;
DROP TABLE Patient CASCADE CONSTRAINTS;
DROP TABLE Insurance_Plan CASCADE CONSTRAINTS;
DROP TABLE Patient_Insurance CASCADE CONSTRAINTS;
DROP TABLE CTCA_Customer_Service_Rep CASCADE CONSTRAINTS;
DROP TABLE New_Patient_Communication CASCADE CONSTRAINTS;
DROP TABLE CTCA_Professional CASCADE CONSTRAINTS;
DROP TABLE Initial_Appointment CASCADE CONSTRAINTS;
DROP TABLE Diagnostic_Test CASCADE CONSTRAINTS;
DROP TABLE Patient_Diagnostic_Test_Result CASCADE CONSTRAINTS;
DROP TABLE Patient_Diagnosis CASCADE CONSTRAINTS;
DROP TABLE Medical_Treatment CASCADE CONSTRAINTS;
DROP TABLE Patient_Medical_Treatment CASCADE CONSTRAINTS;
DROP TABLE Supportive_Therapy CASCADE CONSTRAINTS;
DROP TABLE Patient_Supportive_Therapy CASCADE CONSTRAINTS;

--------------------------------------------------------------------------
-- Table CTCA Location
--------------------------------------------------------------------------

CREATE TABLE CTCA.CTCA_Location
(
    Location_Id     NUMBER NOT NULL,
    Location_Name   VARCHAR2 (100) NOT NULL,
    Address1        VARCHAR2 (200) NOT NULL,
    Address2        VARCHAR2 (200),
    City            VARCHAR2 (200) NOT NULL,
    State           VARCHAR2 (2) NOT NULL,
    Zip_Code        VARCHAR2 (5) NOT NULL,
    Primary_Phone   VARCHAR2 (12) NOT NULL,
    Primary_Email   VARCHAR2 (30) NOT NULL
);

-- Add keys for table CTCA_Location

ALTER TABLE CTCA.CTCA_Location
    ADD CONSTRAINT PK_CTCA_Location PRIMARY KEY (Location_Id);

--------------------------------------------------------------------------
-- Table Patient
--------------------------------------------------------------------------

CREATE TABLE CTCA.Patient
(
    Patient_Id           NUMBER NOT NULL,
    Patient_First_Name   VARCHAR2 (200) NOT NULL,
    Patient_Last_Name    VARCHAR2 (200) NOT NULL,
    Address1             VARCHAR2 (200) NOT NULL,
    Address2             VARCHAR2 (200),
    City                 VARCHAR2 (200) NOT NULL,
    State                VARCHAR2 (2) NOT NULL,
    Zip_Code             VARCHAR2 (5) NOT NULL,
    Patient_Phone        VARCHAR2 (12) NOT NULL,
    Patient_Email        VARCHAR2 (30) NOT NULL,
    Date_Of_Birth        DATE NOT NULL
);

-- Add keys for table Patient ---------------------------------------------------

ALTER TABLE CTCA.Patient
    ADD CONSTRAINT PK_Patient PRIMARY KEY (Patient_Id);

--------------------------------------------------------------------------
-- Table Insurance_Plan
--------------------------------------------------------------------------

CREATE TABLE CTCA.Insurance_Plan
(
    Insurance_Plan_Name   VARCHAR2 (300)
);

-- Add keys for table Insurance_Plan

ALTER TABLE CTCA.Insurance_Plan
    ADD CONSTRAINT PK_Insurance_Plan PRIMARY KEY (Insurance_Plan_Name);

--------------------------------------------------------------------------
-- Table Patient_Insurance
--------------------------------------------------------------------------

CREATE TABLE CTCA.Patient_Insurance
(
    Patient_Id                    NUMBER NOT NULL,
    Insurance_Plan_Name           VARCHAR2 (300) NOT NULL,
    Covered_Amount                NUMBER NOT NULL,
    Patient_Insurance_Confirmed   VARCHAR2 (1) DEFAULT 'N' NOT NULL
);

-- Add keys for table Patient_Insurance

ALTER TABLE CTCA.Patient_Insurance
    ADD CONSTRAINT PK_Patient_Insurance PRIMARY KEY
            (Patient_Id, Insurance_Plan_Name);

ALTER TABLE CTCA.Patient_Insurance
    ADD CONSTRAINT FK_Patient_Insurance_Patient FOREIGN KEY (Patient_Id)
        REFERENCES Patient (Patient_Id);

ALTER TABLE CTCA.Patient_Insurance
    ADD CONSTRAINT FK_Patient_Ins_Ins_Name FOREIGN KEY (Insurance_Plan_Name)
        REFERENCES Insurance_Plan (Insurance_Plan_Name);

--------------------------------------------------------------------------
-- Table CTCA_Customer_Service_Rep
--------------------------------------------------------------------------

CREATE TABLE CTCA.CTCA_Customer_Service_Rep
(
    Customer_Service_Rep_Id   NUMBER NOT NULL,
    First_Name                VARCHAR2 (100) NOT NULL,
    Last_Name                 VARCHAR2 (100) NOT NULL,
    Location_Id               NUMBER NOT NULL
);

ALTER TABLE CTCA.CTCA_Customer_Service_Rep
    ADD CONSTRAINT PK_CTCA_Cust_Serv_Rep PRIMARY KEY
            (Customer_Service_Rep_Id);

ALTER TABLE CTCA.CTCA_Customer_Service_Rep
    ADD CONSTRAINT PK_CTCA_Cust_Serv_Rep_Loc FOREIGN KEY (Location_Id)
        REFERENCES CTCA_Location (Location_Id);

--------------------------------------------------------------------------
-- Table New_Patient_Communication
--------------------------------------------------------------------------

CREATE TABLE CTCA.New_Patient_Communication
(
    Patient_Id                       NUMBER NOT NULL,
    Location_Id                      NUMBER NOT NULL,
    Customer_Service_Rep_Id          NUMBER NOT NULL,
    New_Patient_Communication_Date   DATE NOT NULL,
    Notes                            VARCHAR2 (3000),
    Patient_Insurance_Confirmed      VARCHAR2 (1)
);

-- Add keys for table New_Patient_Communication

ALTER TABLE CTCA.New_Patient_Communication
    ADD CONSTRAINT PK_New_Patient_Comm PRIMARY KEY
            (Patient_Id,
             Location_Id,
             New_Patient_Communication_Date,
             Customer_Service_Rep_Id);

ALTER TABLE CTCA.New_Patient_Communication
    ADD CONSTRAINT FK_New_Patient_Comm_Rep FOREIGN KEY
            (Customer_Service_Rep_Id)
            REFERENCES CTCA_Customer_Service_Rep (Customer_Service_Rep_Id);

ALTER TABLE CTCA.New_Patient_Communication
    ADD CONSTRAINT FK_New_Patient_Comm_Patient FOREIGN KEY (Patient_Id)
        REFERENCES Patient (Patient_Id);

ALTER TABLE CTCA.New_Patient_Communication
    ADD CONSTRAINT FK_New_Patient_Comm_Location FOREIGN KEY (Location_Id)
        REFERENCES CTCA_Location (Location_Id);

--------------------------------------------------------------------------
-- Table CTCA_Professional
--------------------------------------------------------------------------

CREATE TABLE CTCA.CTCA_Professional
(
    CTCA_Professional_Id   NUMBER NOT NULL,
    First_Name             VARCHAR2 (100) NOT NULL,
    Last_Name              VARCHAR2 (100) NOT NULL,
    Location_Id            NUMBER NOT NULL
);

-- Add keys for table CTCA_Professional

ALTER TABLE CTCA.CTCA_Professional
    ADD CONSTRAINT PK_CTCA_Professional PRIMARY KEY (CTCA_Professional_Id);

ALTER TABLE CTCA.CTCA_Professional
    ADD CONSTRAINT FK_CTCA_Prof_Location FOREIGN KEY (Location_Id)
        REFERENCES CTCA_Location (Location_Id);

--------------------------------------------------------------------------
-- Table Initial_Appointment
--------------------------------------------------------------------------

CREATE TABLE CTCA.Initial_Appointment
(
    Patient_Id             NUMBER NOT NULL,
    Location_Id            NUMBER NOT NULL,
    CTCA_Professional_Id   NUMBER NOT NULL,
    Scheduled_Date         DATE NOT NULL,
    Performed_Date         DATE,
    Notes                  VARCHAR2 (3000)
);

-- Add keys for TABLE CTCA.Initial_Appointment

ALTER TABLE CTCA.Initial_Appointment
    ADD CONSTRAINT PK_Initial_Appointment PRIMARY KEY
            (Scheduled_Date,
             CTCA_Professional_Id,
             Patient_Id,
             Location_Id);

ALTER TABLE CTCA.Initial_Appointment
    ADD CONSTRAINT FK_Initial_App_Patient FOREIGN KEY (Patient_Id)
        REFERENCES Patient (Patient_Id);

ALTER TABLE CTCA.Initial_Appointment
    ADD CONSTRAINT FK_Initial_App_Loc FOREIGN KEY (Location_Id)
        REFERENCES CTCA_Location (Location_Id);

ALTER TABLE CTCA.Initial_Appointment
    ADD CONSTRAINT FK_Initial_App_CTCA_Prof FOREIGN KEY
            (CTCA_Professional_Id)
            REFERENCES CTCA_Professional (CTCA_Professional_Id);

--------------------------------------------------------------------------
-- TABLE CTCA.Diagnostic_Test
--------------------------------------------------------------------------

CREATE TABLE CTCA.Diagnostic_Test
(
    Diagnostic_Test_Name          VARCHAR2 (300) NOT NULL,
    Diagnostic_Test_Description   VARCHAR2 (3000) NOT NULL
);

-- Add keys for TABLE CTCA.Diagnostic_Test

ALTER TABLE CTCA.Diagnostic_Test
    ADD CONSTRAINT PK_Diagnostic_Test PRIMARY KEY (Diagnostic_Test_Name);


--------------------------------------------------------------------------
-- TABLE CTCA.Patient_Diagnostic_Test_Result
--------------------------------------------------------------------------

CREATE TABLE CTCA.Patient_Diagnostic_Test_Result
(
    Diagnostic_Test_Result_Id   NUMBER NOT NULL,
    Patient_Id                  NUMBER NOT NULL,
    Diagnostic_Test_Name        VARCHAR2 (300) NOT NULL,
    Diagnostic_Test_Result      VARCHAR2 (300) NOT NULL,
    Date_Performed              DATE NOT NULL,
    CTCA_Professional_Id        NUMBER NOT NULL,
    Location_Id                 NUMBER NOT NULL
);

-- Add keys for TABLE CTCA.Patient_Diagnostic_Test_Result

ALTER TABLE CTCA.Patient_Diagnostic_Test_Result
    ADD CONSTRAINT PK_Patient_Diag_Test_Res PRIMARY KEY
            (Diagnostic_Test_Result_Id);

ALTER TABLE CTCA.Patient_Diagnostic_Test_Result
    ADD CONSTRAINT FK_Patient_Diag_Test_Res_Pat FOREIGN KEY (Patient_Id)
        REFERENCES Patient (Patient_Id);

ALTER TABLE CTCA.Patient_Diagnostic_Test_Result
    ADD CONSTRAINT FK_Patient_Diag_Test_Res_Loc FOREIGN KEY (Location_Id)
        REFERENCES CTCA_Location (Location_Id);

ALTER TABLE CTCA.Patient_Diagnostic_Test_Result
    ADD CONSTRAINT FK_Patient_Diag_Test_Res_Test FOREIGN KEY
            (Diagnostic_Test_Name)
            REFERENCES Diagnostic_Test (Diagnostic_Test_Name);

ALTER TABLE CTCA.Patient_Diagnostic_Test_Result
    ADD CONSTRAINT FK_Patient_Diag_Test_Res_Prof FOREIGN KEY
            (CTCA_Professional_Id)
            REFERENCES CTCA_Professional (CTCA_Professional_Id);

--------------------------------------------------------------------------
-- TABLE CTCA.Patient_Diagnosis
--------------------------------------------------------------------------

CREATE TABLE CTCA.Patient_Diagnosis
(
    Patient_Diagnosis_Id        NUMBER NOT NULL,
    Diagnostic_Test_Result_Id   NUMBER NOT NULL,
    Patient_Id                  NUMBER NOT NULL,
    Diagnosis_Notes             VARCHAR2 (3000) NOT NULL,
    Date_Diagnosis_Given        DATE NOT NULL,
    CTCA_Professional_Id        NUMBER NOT NULL,
    Location_Id                 NUMBER NOT NULL
);

-- Add keys for TABLE CTCA.Patient_Diagnosis

ALTER TABLE CTCA.Patient_Diagnosis
    ADD CONSTRAINT PK_Patient_Diagnosis PRIMARY KEY (Patient_Diagnosis_Id);

ALTER TABLE CTCA.Patient_Diagnosis
    ADD CONSTRAINT FK_Patient_Diagnosis_Pat FOREIGN KEY (Patient_Id)
        REFERENCES Patient (Patient_Id);

ALTER TABLE CTCA.Patient_Diagnosis
    ADD CONSTRAINT FK_Patient_Diagnosis_Loc FOREIGN KEY (Location_Id)
        REFERENCES CTCA_Location (Location_Id);

ALTER TABLE CTCA.Patient_Diagnosis
    ADD CONSTRAINT FK_Patient_Diagnosis_Diag_Test FOREIGN KEY
            (Diagnostic_Test_Result_Id)
            REFERENCES Patient_Diagnostic_Test_Result (Diagnostic_Test_Result_Id);

ALTER TABLE CTCA.Patient_Diagnosis
    ADD CONSTRAINT FK_Patient_Diagnosis_Prof FOREIGN KEY
            (CTCA_Professional_Id)
            REFERENCES CTCA_Professional (CTCA_Professional_Id);

--------------------------------------------------------------------------
-- TABLE CTCA.Medical_Treatment
--------------------------------------------------------------------------

CREATE TABLE CTCA.Medical_Treatment
(
    Medical_Treatment_Name          VARCHAR2 (300) NOT NULL,
    Medical_Treatment_Description   VARCHAR2 (3000)
);

-- Add keys for TABLE CTCA.Medical_Treatment

ALTER TABLE CTCA.Medical_Treatment
    ADD CONSTRAINT PK_Treatment_Name PRIMARY KEY (Medical_Treatment_Name);

--------------------------------------------------------------------------
-- TABLE CTCA.Patient_Medical_Treatment
--------------------------------------------------------------------------

CREATE TABLE CTCA.Patient_Medical_Treatment
(
    Patient_Medical_Treatment_Id   NUMBER NOT NULL,
    Patient_Id                     NUMBER NOT NULL,
    Medical_Treatment_Name         VARCHAR2 (300) NOT NULL,
    Date_Treatment_Given           DATE NOT NULL,
    CTCA_Professional_Id           NUMBER NOT NULL,
    Location_Id                    NUMBER NOT NULL,
    Patient_Diagnosis_Id           NUMBER NOT NULL
);

-- Add keys for TABLE CTCA.Patient_Medical_Treatment

ALTER TABLE CTCA.Patient_Medical_Treatment
    ADD CONSTRAINT PK_Patient_Medical_Treatment PRIMARY KEY
            (Patient_Medical_Treatment_Id);

ALTER TABLE CTCA.Patient_Medical_Treatment
    ADD CONSTRAINT FK_Pat_Med_Treatment_Pat FOREIGN KEY (Patient_Id)
        REFERENCES Patient (Patient_Id);

ALTER TABLE CTCA.Patient_Medical_Treatment
    ADD CONSTRAINT FK_Pat_Med_Treatment_Loc FOREIGN KEY (Location_Id)
        REFERENCES CTCA_Location (Location_Id);

ALTER TABLE CTCA.Patient_Medical_Treatment
    ADD CONSTRAINT FK_Pat_Med_Treatment_Treat FOREIGN KEY
            (Medical_Treatment_Name)
            REFERENCES Medical_Treatment (Medical_Treatment_Name);

ALTER TABLE CTCA.Patient_Medical_Treatment
    ADD CONSTRAINT FK_Pat_Med_Treatment_Prof FOREIGN KEY
            (CTCA_Professional_Id)
            REFERENCES CTCA_Professional (CTCA_Professional_Id);

ALTER TABLE CTCA.Patient_Medical_Treatment
    ADD CONSTRAINT FK_Pat_Med_Treatment_Diag FOREIGN KEY
            (Patient_Diagnosis_Id)
            REFERENCES Patient_Diagnosis (Patient_Diagnosis_Id);

--------------------------------------------------------------------------
-- TABLE CTCA.Supportive_Therapy
--------------------------------------------------------------------------

CREATE TABLE CTCA.Supportive_Therapy
(
    Supportive_Therapy_Name          VARCHAR2 (300) NOT NULL,
    Supportive_Therapy_Description   VARCHAR2 (3000)
);

-- Add keys for TABLE CTCA.Supportive_Therapy

ALTER TABLE CTCA.Supportive_Therapy
    ADD CONSTRAINT PK_Supportive_Therapy PRIMARY KEY
            (Supportive_Therapy_Name);

--------------------------------------------------------------------------
-- TABLE CTCA.Patient_Supportive_Therapy
--------------------------------------------------------------------------

CREATE TABLE CTCA.Patient_Supportive_Therapy
(
    Patient_Supportive_Therapy_Id   NUMBER NOT NULL,
    Patient_Id                      NUMBER NOT NULL,
    Supportive_Therapy_Name         VARCHAR2 (300) NOT NULL,
    Date_Supportive_Therapy_Given   DATE NOT NULL,
    Referred_By_CTCA_Prof_Id        NUMBER NOT NULL,
    Location_Id                     NUMBER NOT NULL,
    Patient_Medical_Treatment_Id    NUMBER NOT NULL
);

-- Add keys for TABLE CTCA.Patient_Supportive_Therapy

ALTER TABLE CTCA.Patient_Supportive_Therapy
    ADD CONSTRAINT PK_Patient_Supportive_Therapy PRIMARY KEY
            (Patient_Supportive_Therapy_Id);

ALTER TABLE CTCA.Patient_Supportive_Therapy
    ADD CONSTRAINT FK_Pat_Sup_Therapy_Pat FOREIGN KEY (Patient_Id)
        REFERENCES Patient (Patient_Id);

ALTER TABLE CTCA.Patient_Supportive_Therapy
    ADD CONSTRAINT FK_Pat_Sup_Therapy_Pat_Loc FOREIGN KEY (Location_Id)
        REFERENCES CTCA_Location (Location_Id);

ALTER TABLE CTCA.Patient_Supportive_Therapy
    ADD CONSTRAINT FK_Patient_Supp_Therapy_Name FOREIGN KEY
            (Supportive_Therapy_Name)
            REFERENCES Supportive_Therapy (Supportive_Therapy_Name);

ALTER TABLE CTCA.Patient_Supportive_Therapy
    ADD CONSTRAINT FK_Patient_Supp_Therapy_Treat FOREIGN KEY
            (Patient_Medical_Treatment_Id)
            REFERENCES Patient_Medical_Treatment (Patient_Medical_Treatment_Id);

--------------------------------------------------------------------------
-- Create Index
--------------------------------------------------------------------------
CREATE UNIQUE INDEX U1_Patient
    ON patient (Patient_First_Name,
                Patient_Last_Name,
                Patient_Phone,
                Date_Of_Birth);

CREATE UNIQUE INDEX U1_CTCA_Professional
    ON CTCA.CTCA_Professional (First_Name, Last_Name, Location_Id);

CREATE INDEX N1_Patient_Diag_Test_Result
    ON Patient_Diagnostic_Test_Result (Patient_Id,
                                       Diagnostic_Test_Name,
                                       Date_Performed,
                                       CTCA_Professional_Id,
                                       Location_Id);

CREATE INDEX N2_Patient_Diag_Test_Result
    ON Patient_Diagnostic_Test_Result (Patient_Id);

CREATE INDEX N1_Patient_Medical_Treatment
    ON CTCA.Patient_Medical_Treatment (Patient_Id,
                                       Medical_Treatment_Name,
                                       Date_Treatment_Given,
                                       CTCA_Professional_Id,
                                       Location_Id,
                                       Patient_Diagnosis_Id);

CREATE INDEX N2_Patient_Medical_Treatment
    ON CTCA.Patient_Medical_Treatment (Patient_Id);

CREATE INDEX N1_Patient_Supportive_Therapy
    ON Patient_Supportive_Therapy (Patient_Id,
                                   Supportive_Therapy_Name,
                                   Date_Supportive_Therapy_Given,
                                   Referred_By_CTCA_Prof_Id,
                                   Location_Id,
                                   Patient_Medical_Treatment_Id);

CREATE INDEX N2_Patient_Supportive_Therapy
    ON Patient_Supportive_Therapy (Patient_Id);

--------------------------------------------------------------------------
-- Create Sequence for Key columns
--------------------------------------------------------------------------
-- Patient

CREATE SEQUENCE Patient_Seq START WITH 1 INCREMENT BY 1;

-- Location

CREATE SEQUENCE Location_Seq START WITH 1 INCREMENT BY 1;

-- CTCA Professional

CREATE SEQUENCE CTCA_Professional_Seq START WITH 1 INCREMENT BY 1;

-- Patient Diagnostic Test Result

CREATE SEQUENCE Diagnostic_test_Result_Seq START WITH 1 INCREMENT BY 1;

-- Patient Diagnosis
CREATE SEQUENCE Patient_Diagnosis_Seq START WITH 1 INCREMENT BY 1;

-- Patient Medical Treatment
CREATE SEQUENCE Patient_Treatment_Seq START WITH 1 INCREMENT BY 1;

-- Patient Supportive Therapy
CREATE SEQUENCE Patient_Supportive_therapy_Seq START WITH 1 INCREMENT BY 1;