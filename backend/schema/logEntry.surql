DEFINE TABLE OVERWRITE logEntry SCHEMAFULL;

# - createdAt: datetime
DEFINE FIELD OVERWRITE createdAt ON logEntry
    TYPE datetime
	READONLY VALUE time::now();

# - updatedAt: datetime
DEFINE FIELD OVERWRITE updatedAt ON logEntry
    TYPE datetime
	VALUE time::now();

# - deletedAt: datetime | NONE
DEFINE FIELD OVERWRITE deletedAt ON logEntry
    TYPE option<datetime>
	DEFAULT NONE;

# - habit ID: recordID
DEFINE FIELD OVERWRITE habitId ON logEntry
    TYPE record<habit>;

# - value: boolean
DEFINE FIELD OVERWRITE value ON logEntry
    TYPE bool;

# - date: Date
DEFINE FIELD OVERWRITE date ON logEntry
    TYPE datetime
    VALUE time::floor($value, 1d);

# - notes: string
DEFINE FIELD OVERWRITE notes ON logEntry
    TYPE string
    DEFAULT ''
    ASSERT $value.len() < 500;

DEFINE INDEX OVERWRITE logEntryUniqueIndex ON TABLE logEntry FIELDS habitId, date UNIQUE;
DEFINE INDEX OVERWRITE logEntryHabitIdIndex ON TABLE logEntry FIELDS habitId;
DEFINE INDEX OVERWRITE logEntryDateIndex ON TABLE logEntry FIELDS date;
DEFINE INDEX OVERWRITE logEntryDeletedAtIndex ON TABLE logEntry FIELDS deletedAt;