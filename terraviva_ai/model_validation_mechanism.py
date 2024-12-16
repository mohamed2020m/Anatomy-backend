from pydantic import BaseModel, ValidationError, constr

# Define the pydantic schema for output validation
class QuestionAnswerSchema(BaseModel):
    questionText: str
    option_a: str
    option_b: str
    option_c: str
    option_d: str
    correctAnswer: constr(min_length=1) # type: ignore

def validate_output(result):
    """
    Validate the model output using the QuestionAnswerSchema.
    :param result: The dictionary output from the model.
    :return: Validated result or None if invalid.
    """
    try:
        # Validate with pydantic
        validated_result = QuestionAnswerSchema(**result)
        # print("validated: ", validated_result.dict().keys())
        
        # Check if correct_answer is one of the keys in the validated result
        if validated_result.correctAnswer not in validated_result.dict().keys():
            return None 
        
        # print("validated_result: ", validated_result)
        
        return validated_result
    except ValidationError as e:
        print(f"Validation Error: {e}")
        return None
