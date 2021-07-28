const emptyName = 'Name must not be empty.';
const tooLongName = 'Name too long.';
const emptyCharacteristics = 'Characteristics must not be empty.';
const tooLongCharacteristics =
    'Characteristics must not exceed 250 characters.';

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return emptyName;
  }
  if (value.trim().length > 30) {
    return tooLongName;
  }
}

String? validateCharacteristics(String? value) {
  if (value == null || value.isEmpty) {
    return emptyCharacteristics;
  }
  if (value.trim().length > 250) {
    return tooLongCharacteristics;
  }
}
