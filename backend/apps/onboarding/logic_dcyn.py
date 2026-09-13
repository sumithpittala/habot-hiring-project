def evaluate_dcyn_eligibility(payload: dict) -> bool:
    """
    Deconstructs incoming JSON payload into binary Yes/No decisions (DCYN Library).
    Returns True if student meets mandatory LSA onboarding rules, else False.
    """
    has_valid_age = 3 <= payload.get("student_age", 0) <= 18
    has_medical_assessment = payload.get("has_completed_assessment") is True
    requires_lsa_support = payload.get("requires_lsa") is True

    # Deterministic Binary Logic (DCYN)
    is_eligible = bool(
        has_valid_age and has_medical_assessment and requires_lsa_support
    )
    return is_eligible
