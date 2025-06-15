/******************************************************************************/
/***                                 Tables                                 ***/
/******************************************************************************/

CREATE TABLE VH_INFUSION (
    UUID_INFUSION                  D_STRING255 NOT NULL /* D_STRING255 = VARCHAR(255) */,
    DATE_VH                        D_DT NOT NULL /* D_DT = TIMESTAMP */,
    GROUP_VH                       D_INT NOT NULL /* D_INT = INTEGER*/,
    INDEX_VH                       D_INT NOT NULL /* D_INT = INTEGER*/,
    TYPE_VH                        D_STRING255 NOT NULL /* D_STRING255 = VARCHAR(255) */,
    BAG_VOLUME                     D_INT NOT NULL /* D_INT = INTEGER*/,
    BAG_NAME                       D_STRING255 NOT NULL /* D_STRING255 = VARCHAR(255) */,
    FLOW_RATE                      D_FLOAT NOT NULL /* D_FLOAT = NUMERIC */,
    QUANTITY_BASE_COMPLETED        D_INT NOT NULL /* D_INT = INTEGER*/,
    QUANTITY_BASE_SCHEDULED        D_INT NOT NULL /* D_INT = INTEGER*/,
    BASE_ACT_EXTERNAL_ID           D_STRING255 DEFAULT NULL/* D_STRING255 = VARCHAR(255) */,
    BASE_ACT_BILLABLE              D_BOOLEAN NOT NULL /* D_BOOLEAN = CHAR default F value in ('T', 'F') */,
    BASE_ACT_ID_RAF                D_INT DEFAULT NULL /* D_INT = INTEGER*/,
    CRI_ACT_EXTERNAL_ID            D_STRING255 DEFAULT NULL/* D_STRING255 = VARCHAR(255) */,
    CRI_ACT_BILLABLE               D_BOOLEAN NOT NULL /* D_BOOLEAN = CHAR default F value in ('T', 'F') */,
    CRI_ACT_ID_RAF                 D_INT DEFAULT NULL /* D_INT = INTEGER*/,
    DT_EDIT                        D_DT NOT NULL /* D_DT = TIMESTAMP */,
    ID_HOSPITALIZATION             D_ID NOT NULL /* D_ID = INTEGER default -1 NOT NULL */
);

CREATE TABLE VH_ADMIXTURE (
    UUID_ADMIXTURE            D_STRING255 NOT NULL /* D_STRING255 = VARCHAR(255) */,
    ACT_BILLABLE              D_BOOLEAN NOT NULL /* D_BOOLEAN = CHAR default F value in ('T', 'F') */,
    ACT_EXTERNAL_ID           D_STRING255 NOT NULL /* D_STRING255 = VARCHAR(255) */,
    ACT_ID_RAF                D_INT DEFAULT NULL /* D_INT = INTEGER*/,
    NAME                      D_STRING255 NOT NULL /* D_STRING255 = VARCHAR(255) */,
    UNIT                      D_STRING255 NOT NULL /* D_STRING255 = VARCHAR(255) */,
    QUANTITY                  D_FLOAT NOT NULL /* D_FLOAT = NUMERIC */,
    PER_DAY                   D_BOOLEAN NOT NULL /* D_BOOLEAN = CHAR default F value in ('T', 'F') */,
    DT_EDIT                   D_DT NOT NULL /* D_DT = TIMESTAMP */,
    UUID_INFUSION             D_STRING255 NOT NULL /* D_ID = INTEGER default -1 NOT NULL */
);

CREATE TABLE VH_CRI_ITEM (
    UUID_CRI_ITEM             D_STRING255 NOT NULL /* D_STRING255 = VARCHAR(255) */,
    ACT_BILLABLE              D_BOOLEAN NOT NULL /* D_BOOLEAN = CHAR default F value in ('T', 'F') */,
    ACT_EXTERNAL_ID           D_STRING255 NOT NULL /* D_STRING255 = VARCHAR(255) */,
    ACT_ID_RAF                D_INT DEFAULT NULL /* D_INT = INTEGER*/,
    QUANTITY                  D_FLOAT NOT NULL /* D_FLOAT = NUMERIC */,
    DT_EDIT                   D_DT NOT NULL /* D_DT = TIMESTAMP */,
    UUID_INFUSION             D_STRING255 NOT NULL /* D_ID = INTEGER default -1 NOT NULL */
);

/******************************************************************************/
/***                              Primary keys                              ***/
/******************************************************************************/

ALTER TABLE VH_INFUSION ADD CONSTRAINT PK_VH_INFUSION PRIMARY KEY (UUID_INFUSION);
ALTER TABLE VH_ADMIXTURE ADD CONSTRAINT PK_VH_ADMIXTURE PRIMARY KEY (UUID_ADMIXTURE);
ALTER TABLE VH_CRI_ITEM ADD CONSTRAINT PK_VH_CRI_ITEM PRIMARY KEY (UUID_CRI_ITEM);

/******************************************************************************/
/***                                Foreign Keys                            ***/
/******************************************************************************/

ALTER TABLE VH_INFUSION 
   ADD CONSTRAINT FK_VH_INFUSION_HOSPIT FOREIGN KEY (ID_HOSPITALIZATION) REFERENCES VH_HOSPITALIZATION(ID_HOSPITALIZATION) ON DELETE CASCADE;

ALTER TABLE VH_ADMIXTURE 
   ADD CONSTRAINT FK_VH_ADMIXTURE_INFUSION FOREIGN KEY (UUID_INFUSION) REFERENCES VH_INFUSION(UUID_INFUSION) ON DELETE CASCADE;

ALTER TABLE VH_CRI_ITEM 
   ADD CONSTRAINT FK_VH_CRI_ITEM_INFUSION FOREIGN KEY (UUID_INFUSION) REFERENCES VH_INFUSION(UUID_INFUSION) ON DELETE CASCADE;
