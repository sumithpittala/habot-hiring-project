from rest_framework import serializers

from .logic_dcyn import evaluate_dcyn_eligibility


class StudentOnboardingSerializer(serializers.Serializer):
    student_id = serializers.CharField(max_length=36, min_length=36)  # UUID string
    student_age = serializers.IntegerField(min_value=3, max_value=18)
    guardian_email = serializers.EmailField(max_length=254)
    has_completed_assessment = serializers.BooleanField()
    requires_lsa = serializers.BooleanField()

    def validate(self, attrs):
        # Enforce DCYN Binary Decision Rules
        is_eligible = evaluate_dcyn_eligibility(attrs)
        attrs["is_eligible"] = is_eligible

        if not is_eligible and attrs.get("requires_lsa"):
            raise serializers.ValidationError(
                "Student requires LSA support but has not completed the requisite medical assessment."
            )
        return attrs
