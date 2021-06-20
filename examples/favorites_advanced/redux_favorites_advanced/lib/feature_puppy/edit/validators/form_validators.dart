const allowedNameLength = 30;
const nameEmptyError = 'Name must not be empty.';
const nameLengthError = 'Name too long.';

const allowedCharacteristicsLength = 250;
const characteristicsEmptyError = 'Characteristics must not be empty.';
const characteristicsLengthError =
    'Characteristics must not exceed $allowedCharacteristicsLength characters.';

String nameValidator(String name) => (name.isEmpty)
    ? nameEmptyError
    : (name.length > allowedNameLength)
        ? nameLengthError
        : '';

String characteristicsValidator(String characteristics) =>
    (characteristics.isEmpty)
        ? characteristicsEmptyError
        : (characteristics.length > allowedCharacteristicsLength)
            ? characteristicsLengthError
            : '';
