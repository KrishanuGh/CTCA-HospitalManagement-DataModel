--------------------------------------------------------------------------
-- Add Patient
--------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE Add_Patient (p_Patient_First_Name   IN VARCHAR2,
                                         p_Patient_Last_Name    IN VARCHAR2,
                                         p_Address1             IN VARCHAR2,
                                         p_Address2             IN VARCHAR2,
                                         p_City                 IN VARCHAR2,
                                         p_State                IN VARCHAR2,
                                         p_Zip_Code             IN VARCHAR2,
                                         p_Patient_Phone        IN VARCHAR2,
                                         p_Patient_Email        IN VARCHAR2,
                                         p_Date_Of_Birth        IN DATE)
AS
BEGIN
    INSERT INTO patient (Patient_Id,
                         Patient_First_Name,
                         Patient_Last_Name,
                         Address1,
                         Address2,
                         City,
                         State,
                         Zip_Code,
                         Patient_Phone,
                         Patient_Email,
                         Date_Of_Birth)
         VALUES (Patient_Seq.NEXTVAL,
                 p_Patient_First_Name,
                 p_Patient_Last_Name,
                 p_Address1,
                 p_Address2,
                 p_City,
                 p_State,
                 p_Zip_Code,
                 p_Patient_Phone,
                 p_Patient_Email,
                 p_Date_Of_Birth);

    COMMIT;
END;
--------------------------------------------------------------------------
-- Add Insurance
--------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE Add_Insurance (p_Insurance_Plan_Name   IN VARCHAR2)
AS
BEGIN
    INSERT INTO Insurance_Plan (Insurance_Plan_Name)
         VALUES (p_Insurance_Plan_Name);

    COMMIT;
END;

--------------------------------------------------------------------------
-- Add Patient Insurance
--------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE Add_Patient_Insurance (
    p_Patient_First_Name    IN VARCHAR2,
    p_Patient_Last_Name     IN VARCHAR2,
    p_Patient_Phone         IN VARCHAR2,
    p_Date_Of_Birth         IN DATE,
    P_Insurance_Plan_Name      VARCHAR2,
    p_Covered_Amount           NUMBER)
AS
    var_patient_id   NUMBER;
BEGIN
    BEGIN
        SELECT patient_id
          INTO var_patient_id
          FROM patient
         WHERE     LTRIM (RTRIM (UPPER (Patient_First_Name))) =
                       LTRIM (RTRIM (UPPER (p_Patient_First_Name)))
               AND LTRIM (RTRIM (UPPER (Patient_Last_Name))) =
                       LTRIM (RTRIM (UPPER (p_Patient_Last_Name)))
               AND Patient_Phone = p_Patient_Phone
               AND Date_Of_Birth = p_Date_Of_Birth;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            DBMS_OUTPUT.PUT_LINE ('No Matched PAtient record found');
    END;

    INSERT
      INTO Patient_Insurance (Patient_Id, Insurance_Plan_Name, Covered_Amount)
    VALUES (var_patient_id, P_Insurance_Plan_Name, p_Covered_Amount);
END;

--------------------------------------------------------------------------
-- Add Location
--------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE Add_Location (p_Location_Name   IN VARCHAR2,
                                          p_Address1        IN VARCHAR2,
                                          p_Address2        IN VARCHAR2,
                                          p_City            IN VARCHAR2,
                                          p_State           IN VARCHAR2,
                                          p_Zip_Code        IN VARCHAR2,
                                          p_Primary_Phone   IN VARCHAR2,
                                          p_Primary_Email   IN VARCHAR2)
AS
BEGIN
    INSERT INTO CTCA_Location (Location_Id,
                               Location_Name,
                               Address1,
                               Address2,
                               City,
                               State,
                               Zip_Code,
                               Primary_Phone,
                               Primary_Email)
         VALUES (Location_Seq.NEXTVAL,
                 p_Location_Name,
                 p_Address1,
                 p_Address2,
                 p_City,
                 p_State,
                 p_Zip_Code,
                 p_Primary_Phone,
                 p_Primary_Email);

    COMMIT;
END;

--------------------------------------------------------------------------
-- Get Location Id from Location Name
--------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_location_id (p_location_name IN VARCHAR2)
    RETURN NUMBER
IS
    var_location_id   NUMBER;
BEGIN
    BEGIN
        SELECT location_id
          INTO var_location_id
          FROM CTCA_location
         WHERE LTRIM (RTRIM (UPPER (location_Name))) =
                   LTRIM (RTRIM (UPPER (p_location_Name)));
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            DBMS_OUTPUT.PUT_LINE ('No Matched Location found');
    END;

    RETURN var_location_id;
END;

--------------------------------------------------------------------------
-- Get Patient Id from Patient Name
--------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_Patient_id (
    p_Patient_First_Name   IN VARCHAR2,
    p_Patient_Last_Name    IN VARCHAR2,
    p_Patient_Phone        IN VARCHAR2,
    p_Date_Of_Birth        IN DATE)
    RETURN NUMBER
IS
    var_patient_id   NUMBER;
BEGIN
    BEGIN
        SELECT patient_id
          INTO var_patient_id
          FROM patient
         WHERE     LTRIM (RTRIM (UPPER (Patient_First_Name))) =
                       LTRIM (RTRIM (UPPER (p_Patient_First_Name)))
               AND LTRIM (RTRIM (UPPER (Patient_Last_Name))) =
                       LTRIM (RTRIM (UPPER (p_Patient_Last_Name)))
               AND Patient_Phone = p_Patient_Phone
               AND Date_Of_Birth = p_Date_Of_Birth;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            DBMS_OUTPUT.PUT_LINE ('No Matched Patient record found');
            var_patient_id := NULL;
    END;

    RETURN var_patient_id;
END;
--------------------------------------------------------------------------
-- Add CTCA Professional
--------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE Add_CTCA_Professional (
    p_First_Name      IN VARCHAR2,
    p_Last_Name       IN VARCHAR2,
    p_Location_name   IN VARCHAR2)
AS
    var_location_id   NUMBER;
BEGIN
    INSERT INTO CTCA_Professional (CTCA_Professional_Id,
                                   First_Name,
                                   Last_Name,
                                   Location_Id)
         VALUES (CTCA_Professional_Seq.NEXTVAL,
                 p_first_name,
                 p_last_name,
                 get_location_id (p_location_name));

    COMMIT;
END;

--------------------------------------------------------------------------
-- Get CTCA Professional Id from NAme, Location
--------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_CTCA_Professional_id (
    p_first_name      IN VARCHAR2,
    p_last_name       IN VARCHAR2,
    p_location_name   IN VARCHAR2)
    RETURN NUMBER
IS
    var_ctca_prof_id   NUMBER;
BEGIN
    BEGIN
        SELECT CTCA_Professional_Id
          INTO var_ctca_prof_id
          FROM CTCA_Professional
         WHERE     LTRIM (RTRIM (UPPER (first_Name))) =
                       LTRIM (RTRIM (UPPER (p_first_Name)))
               AND LTRIM (RTRIM (UPPER (last_Name))) =
                       LTRIM (RTRIM (UPPER (p_last_Name)))
               AND location_id = get_location_id (p_location_name);
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            DBMS_OUTPUT.PUT_LINE ('No Matched CTCA Professional found');
    END;

    RETURN var_ctca_prof_id;
END;

--------------------------------------------------------------------------
-- Add Patient Initial Appointment
--------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE Add_Initial_appointment (
    p_Patient_First_Name     IN VARCHAR2,
    p_Patient_Last_Name      IN VARCHAR2,
    p_Patient_Phone          IN VARCHAR2,
    p_Date_Of_Birth          IN DATE,
    P_Location_Name          IN VARCHAR2,
    p_CTCA_prof_First_Name   IN VARCHAR2,
    p_CTCA_prof_Last_Name    IN VARCHAR2,
    p_Scheduled_Date         IN DATE,
    p_Performed_Date         IN DATE,
    p_Notes                  IN VARCHAR2)
AS
BEGIN
	INSERT INTO Initial_Appointment (Patient_Id,
                                     Location_Id,
                                     CTCA_Professional_Id,
                                     Scheduled_Date,
                                     Performed_Date,
                                     Notes)
             VALUES (
                        get_Patient_id (p_Patient_First_Name,
                                        p_Patient_Last_Name,
                                        p_Patient_Phone,
                                        p_Date_Of_Birth),
                        get_location_id (p_location_name),
                        get_CTCA_Professional_Id (p_CTCA_prof_First_Name,
                                                  p_CTCA_prof_Last_Name,
                                                  P_Location_Name),
                        p_Scheduled_Date,
                        p_Performed_Date,
                        p_Notes);
	COMMIT;
END;

--------------------------------------------------------------------------
-- Add Diagnostic Test Name
--------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE Add_Diagnostic_Test (
    p_Diagnostic_Test_Name   IN VARCHAR2,
    P_Diagnostic_Test_Desc   IN VARCHAR2)
AS
BEGIN
    INSERT
      INTO CTCA.Diagnostic_Test (Diagnostic_Test_Name,
                                 Diagnostic_Test_Description)
    VALUES (p_Diagnostic_Test_Name, p_Diagnostic_Test_Desc);

    COMMIT;
END;


--------------------------------------------------------------------------
-- Add Patient Diagnostic test result
--------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE Add_Patient_Diag_Test_Result (
    p_Patient_First_Name       IN VARCHAR2,
    p_Patient_Last_Name        IN VARCHAR2,
    p_Patient_Phone            IN VARCHAR2,
    p_Date_Of_Birth            IN DATE,
    P_Location_Name            IN VARCHAR2,
    p_CTCA_prof_First_Name     IN VARCHAR2,
    p_CTCA_prof_Last_Name      IN VARCHAR2,
    p_Diagnostic_Test_Name     IN VARCHAR2,
    p_Diagnostic_Test_Result   IN VARCHAR2,
    p_Date_Performed           IN DATE)
AS
BEGIN
    INSERT
      INTO CTCA.Patient_Diagnostic_Test_Result (Diagnostic_Test_Result_Id,
                                                Patient_Id,
                                                Diagnostic_Test_Name,
                                                Diagnostic_Test_Result,
                                                Date_Performed,
                                                CTCA_Professional_Id,
                                                Location_Id)
        VALUES (
                   Diagnostic_test_Result_Seq.NEXTVAL,
                   get_Patient_id (p_Patient_First_Name,
                                   p_Patient_Last_Name,
                                   p_Patient_Phone,
                                   p_Date_Of_Birth),
                   p_Diagnostic_Test_Name,
                   p_Diagnostic_Test_Result,
                   p_Date_Performed,
                   get_CTCA_Professional_Id (p_CTCA_prof_First_Name,
                                             p_CTCA_prof_Last_Name,
                                             P_Location_Name),
                   get_location_id (p_location_name));

    COMMIT;
END;

--------------------------------------------------------------------------
-- Get patient diagnostic Test Result Id
--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION Get_Pat_Diag_Test_Result_Id (
    p_Patient_First_Name     IN VARCHAR2,
    p_Patient_Last_Name      IN VARCHAR2,
    p_Patient_Phone          IN VARCHAR2,
    p_Date_Of_Birth          IN DATE,
    P_Location_Name          IN VARCHAR2,
    p_CTCA_prof_First_Name   IN VARCHAR2,
    p_CTCA_prof_Last_Name    IN VARCHAR2,
    p_Diagnostic_Test_Name   IN VARCHAR2,
    p_Date_Performed         IN DATE)
    RETURN NUMBER
IS
    var_pat_test_result_id   NUMBER;
BEGIN
    SELECT Diagnostic_Test_Result_Id
      INTO var_pat_test_result_id
      FROM Patient_Diagnostic_Test_Result
     WHERE     Patient_Id = get_Patient_id (p_Patient_First_Name,
                                            p_Patient_Last_Name,
                                            p_Patient_Phone,
                                            p_Date_Of_Birth)
           AND Diagnostic_Test_Name = p_Diagnostic_Test_Name
           AND Date_Performed = p_Date_Performed
           AND CTCA_Professional_Id =
                   get_CTCA_Professional_Id (p_CTCA_prof_First_Name,
                                             p_CTCA_prof_Last_Name,
                                             P_Location_Name)
           AND Location_Id = get_location_id (p_location_name);

    RETURN var_pat_test_result_id;
END;
--------------------------------------------------------------------------
-- Add Patient Diagnosis
--------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE Add_Patient_Diagnosis (
    p_Patient_First_Name     IN VARCHAR2,
    p_Patient_Last_Name      IN VARCHAR2,
    p_Patient_Phone          IN VARCHAR2,
    p_Date_Of_Birth          IN DATE,
    P_Location_Name          IN VARCHAR2,
    p_CTCA_prof_First_Name   IN VARCHAR2,
    p_CTCA_prof_Last_Name    IN VARCHAR2,
    p_Diagnostic_Test_Name   IN VARCHAR2,
    p_Date_Performed         IN DATE,
    p_date_diagnosis_given   IN DATE,
    p_Diagnosis_Notes        IN VARCHAR2)
AS
BEGIN
    INSERT INTO CTCA.Patient_Diagnosis (Patient_Diagnosis_Id,
                                        Diagnostic_Test_Result_Id,
                                        Patient_Id,
                                        Diagnosis_Notes,
                                        Date_Diagnosis_Given,
                                        CTCA_Professional_Id,
                                        Location_Id)
             VALUES (
                        Patient_Diagnosis_Seq.NEXTVAL,
                        Get_Pat_Diag_Test_Result_Id (p_Patient_First_Name,
                                                     p_Patient_Last_Name,
                                                     p_Patient_Phone,
                                                     p_Date_Of_Birth,
                                                     P_Location_Name,
                                                     p_CTCA_prof_First_Name,
                                                     p_CTCA_prof_Last_Name,
                                                     p_Diagnostic_Test_Name,
                                                     p_Date_Performed),
                        get_Patient_id (p_Patient_First_Name,
                                        p_Patient_Last_Name,
                                        p_Patient_Phone,
                                        p_Date_Of_Birth),
                        p_Diagnosis_Notes,
                        p_Date_diagnosis_given,
                        get_CTCA_Professional_Id (p_CTCA_prof_First_Name,
                                                  p_CTCA_prof_Last_Name,
                                                  P_Location_Name),
                        get_location_id (p_location_name));

    COMMIT;
END;

---------------------------------------------------------------------------
-- Get Patient Diagnosis Id
---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION Get_Patient_Diagnosis_id (
    p_Patient_First_Name     IN VARCHAR2,
    p_Patient_Last_Name      IN VARCHAR2,
    p_Patient_Phone          IN VARCHAR2,
    p_Date_Of_Birth          IN DATE,
    P_Location_Name          IN VARCHAR2,
    p_CTCA_prof_First_Name   IN VARCHAR2,
    p_CTCA_prof_Last_Name    IN VARCHAR2,
    p_date_diagnosis_given   IN DATE)
    RETURN NUMBER
IS
    var_pat_diagnosis_id   NUMBER;
BEGIN
    SELECT Patient_Diagnosis_Id
      INTO var_pat_diagnosis_id
      FROM Patient_Diagnosis
     WHERE     Patient_Id = get_Patient_id (p_Patient_First_Name,
                                            p_Patient_Last_Name,
                                            p_Patient_Phone,
                                            p_Date_Of_Birth)
           AND CTCA_Professional_Id =
                   get_CTCA_Professional_Id (p_CTCA_prof_First_Name,
                                             p_CTCA_prof_Last_Name,
                                             P_Location_Name)
           AND Date_Diagnosis_Given = p_Date_diagnosis_given
           AND Location_Id = get_location_id (p_location_name);

    RETURN var_pat_diagnosis_id;
END;


--------------------------------------------------------------------------
-- Add Medical Treatment Name
--------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE Add_Medical_Treatment (
    p_Medical_Treatment_Name   IN VARCHAR2,
    p_Medical_Treatment_Desc   IN VARCHAR2)
AS
BEGIN
    INSERT
      INTO CTCA.Medical_Treatment (Medical_Treatment_Name,
                                   Medical_Treatment_Description)
    VALUES (p_Medical_Treatment_Name, p_Medical_Treatment_desc);

    COMMIT;
END;

--------------------------------------------------------------------------
-- Add Patient Medical Treatment
--------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE Add_Patient_Medical_Treatment (
    p_Patient_First_Name       IN VARCHAR2,
    p_Patient_Last_Name        IN VARCHAR2,
    p_Patient_Phone            IN VARCHAR2,
    p_Date_Of_Birth            IN DATE,
    P_Location_Name            IN VARCHAR2,
    p_CTCA_prof_First_Name     IN VARCHAR2,
    p_CTCA_prof_Last_Name      IN VARCHAR2,
    p_date_diagnosis_given     IN DATE,
    p_medical_treatment_name   IN VARCHAR2,
    p_date_treatment_given     IN DATE)
AS
BEGIN
    INSERT INTO CTCA.Patient_Medical_Treatment (Patient_Medical_Treatment_Id,
                                                Patient_Id,
                                                Medical_Treatment_Name,
                                                Date_Treatment_Given,
                                                CTCA_Professional_Id,
                                                Location_Id,
                                                Patient_Diagnosis_Id)
             VALUES (
                        Patient_Treatment_Seq.NEXTVAL,
                        get_Patient_id (p_Patient_First_Name,
                                        p_Patient_Last_Name,
                                        p_Patient_Phone,
                                        p_Date_Of_Birth),
                        p_medical_treatment_name,
                        p_date_treatment_given,
                        get_CTCA_Professional_Id (p_CTCA_prof_First_Name,
                                                  p_CTCA_prof_Last_Name,
                                                  P_Location_Name),
                        get_location_id (p_location_name),
                        Get_Patient_Diagnosis_id (p_Patient_First_Name,
                                                  p_Patient_Last_Name,
                                                  p_Patient_Phone,
                                                  p_Date_Of_Birth,
                                                  P_Location_Name,
                                                  p_CTCA_prof_First_Name,
                                                  p_CTCA_prof_Last_Name,
                                                  p_date_diagnosis_given));

    COMMIT;
END;

--------------------------------------------------------------------------
-- Get Patient Treatment ID
--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION Get_Patient_Treatment_id (
    p_Patient_First_Name       IN VARCHAR2,
    p_Patient_Last_Name        IN VARCHAR2,
    p_Patient_Phone            IN VARCHAR2,
    p_Date_Of_Birth            IN DATE,
    P_Location_Name            IN VARCHAR2,
    p_CTCA_prof_First_Name     IN VARCHAR2,
    p_CTCA_prof_Last_Name      IN VARCHAR2,
    p_Medical_Treatment_Name   IN VARCHAR2,
    p_Date_Treatment_Given     IN DATE)
    RETURN NUMBER
IS
    var_pat_med_treatment_id   NUMBER;
BEGIN
    SELECT Patient_Medical_Treatment_Id
      INTO var_pat_med_treatment_id
      FROM Patient_Medical_Treatment
     WHERE     Patient_Id = get_Patient_id (p_Patient_First_Name,
                                            p_Patient_Last_Name,
                                            p_Patient_Phone,
                                            p_Date_Of_Birth)
           AND Medical_Treatment_Name = p_Medical_Treatment_Name
           AND Date_Treatment_Given = p_Date_Treatment_Given
           AND CTCA_Professional_Id =
                   get_CTCA_Professional_Id (p_CTCA_prof_First_Name,
                                             p_CTCA_prof_Last_Name,
                                             P_Location_Name)
           AND Location_Id = get_location_id (p_location_name);

    RETURN var_pat_med_treatment_id;
END;

--------------------------------------------------------------------------
-- Get Patient Medical Treatment ID
--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION Get_Patient_Treatment_id (
    p_Patient_First_Name     IN VARCHAR2,
    p_Patient_Last_Name      IN VARCHAR2,
    p_Patient_Phone          IN VARCHAR2,
    p_Date_Of_Birth          IN DATE,
    P_Location_Name          IN VARCHAR2,
    p_CTCA_prof_First_Name   IN VARCHAR2,
    p_CTCA_prof_Last_Name    IN VARCHAR2,
    p_Medical_Treatment_Name IN VARCHAR2,
    p_Date_Treatment_Given   IN DATE)
    RETURN NUMBER
IS
    var_pat_med_treatment_id    NUMBER;
BEGIN
 SELECT Patient_Medical_Treatment_Id
   INTO var_pat_med_treatment_id
   FROM Patient_Medical_Treatment
  WHERE Patient_Id = get_Patient_id (p_Patient_First_Name,
                                        p_Patient_Last_Name,
                                        p_Patient_Phone,
                                        p_Date_Of_Birth)
	AND Medical_Treatment_Name = p_Medical_Treatment_Name
	AND Date_Treatment_Given = p_Date_Treatment_Given
	AND CTCA_Professional_Id = get_CTCA_Professional_Id (p_CTCA_prof_First_Name,
                                                  p_CTCA_prof_Last_Name,
                                                  P_Location_Name)
    AND Location_Id = get_location_id (p_location_name);
	
   RETURN var_pat_med_treatment_id;
END;
--------------------------------------------------------------------------
-- Add Supportive Therapy
--------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE Add_Supportive_Therapy (
    p_Supportive_Therapy_Name   IN VARCHAR2,
    p_Supportive_Therapy_Desc   IN VARCHAR2)
AS
BEGIN
    INSERT
      INTO CTCA.Supportive_Therapy (Supportive_Therapy_Name,
                                    Supportive_Therapy_Description)
    VALUES (p_Supportive_Therapy_Name, p_Supportive_Therapy_Desc);

    COMMIT;
END;

--------------------------------------------------------------------------
-- Add Patient Supportive Therapy
--------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE Add_Patient_Supportive_Therapy (
    p_Patient_First_Name        IN VARCHAR2,
    p_Patient_Last_Name         IN VARCHAR2,
    p_Patient_Phone             IN VARCHAR2,
    p_Date_Of_Birth             IN DATE,
    P_Location_Name             IN VARCHAR2,
    p_CTCA_prof_First_Name      IN VARCHAR2,
    p_CTCA_prof_Last_Name       IN VARCHAR2,
    p_medical_treatment_name    IN VARCHAR2,
    p_date_treatment_given      IN DATE,
    p_supportive_therapy_name   IN VARCHAR2,
    p_date_therapy_given        IN DATE)
AS
BEGIN
    INSERT
      INTO CTCA.Patient_Supportive_Therapy (Patient_Supportive_Therapy_Id,
                                            Patient_Id,
                                            Supportive_Therapy_Name,
                                            Date_Supportive_Therapy_Given,
                                            Referred_By_CTCA_Prof_Id,
                                            Location_Id,
                                            Patient_Medical_Treatment_Id)
        VALUES (
                   Patient_Supportive_therapy_Seq.NEXTVAL,
                   get_Patient_id (p_Patient_First_Name,
                                   p_Patient_Last_Name,
                                   p_Patient_Phone,
                                   p_Date_Of_Birth),
                   p_supportive_therapy_name,
                   p_date_therapy_given,
                   get_CTCA_Professional_Id (p_CTCA_prof_First_Name,
                                             p_CTCA_prof_Last_Name,
                                             P_Location_Name),
                   get_location_id (p_location_name),
                   Get_Patient_Treatment_id (p_Patient_First_Name,
                                             p_Patient_Last_Name,
                                             p_Patient_Phone,
                                             p_Date_Of_Birth,
                                             P_Location_Name,
                                             p_CTCA_prof_First_Name,
                                             p_CTCA_prof_Last_Name,
                                             p_Medical_Treatment_Name,
                                             p_Date_Treatment_Given));

    COMMIT;
END;

