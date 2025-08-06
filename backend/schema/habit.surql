DEFINE TABLE OVERWRITE habit SCHEMAFULL;

# - createdAt: datetime
DEFINE FIELD OVERWRITE createdAt ON habit
    TYPE datetime
	READONLY VALUE time::now();

# - updatedAt: datetime
DEFINE FIELD OVERWRITE updatedAt ON habit
    TYPE datetime
	VALUE time::now();

# - deletedAt: datetime | NONE
DEFINE FIELD OVERWRITE deletedAt ON habit
    TYPE option<datetime>
	DEFAULT NONE;

# - name: string
DEFINE FIELD OVERWRITE name ON habit
    TYPE string
    ASSERT $value.len() > 2;


# - description: string
DEFINE FIELD OVERWRITE description ON habit
    TYPE string
    DEFAULT ''
    ASSERT $value.len() < 500;

DEFINE INDEX OVERWRITE habitNameIndex ON TABLE habit FIELDS name UNIQUE;
DEFINE INDEX OVERWRITE habitDeletedAtIndex ON TABLE habit FIELDS deletedAt;