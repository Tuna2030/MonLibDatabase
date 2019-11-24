
CREATE TABLE author (
    authorid     NUMBER(10) NOT NULL,
    authorname   VARCHAR2(100) NOT NULL
);

ALTER TABLE author ADD CONSTRAINT author_pk PRIMARY KEY ( authorid );

CREATE TABLE authortitle (
    title_callno      VARCHAR2(20) NOT NULL,
    author_authorid   NUMBER(10) NOT NULL
);

ALTER TABLE authortitle ADD CONSTRAINT authortitle_pk PRIMARY KEY ( title_callno,
author_authorid );

CREATE TABLE bookcopy (
    barcodeno         NUMBER(20) NOT NULL,
    status            VARCHAR2(50) NOT NULL,
    price             NUMBER(8,2) NOT NULL,
    branch_branchid   NUMBER(3) NOT NULL,
    identifier_isbn   VARCHAR2(50) NOT NULL
);

ALTER TABLE bookcopy
    ADD CHECK ( status IN (
        'Available',
        'Loaned',
        'Reserved'
    ) );

ALTER TABLE bookcopy ADD CONSTRAINT bookcopy_pk PRIMARY KEY ( barcodeno );

CREATE TABLE branch (
    branchid            NUMBER(3) NOT NULL,
    branchname          VARCHAR2(50) NOT NULL,
    branchaddress       VARCHAR2(100) NOT NULL,
    branchphone         VARCHAR2(13) NOT NULL,
    manager_managerid   NUMBER(10) NOT NULL,
    CHECK (branchid>=100)
);

ALTER TABLE branch ADD CONSTRAINT branch_pk PRIMARY KEY ( branchid );

CREATE TABLE burrower (
    burrowerid               NUMBER(10) NOT NULL,
    burrowername             VARCHAR2(50) NOT NULL,
    burroweraddress          VARCHAR2(100) NOT NULL,
    burrowerhomebranch       NUMBER(3) NOT NULL,
    burrowerphone            VARCHAR2(13) NOT NULL,
    burroweremail            VARCHAR2(50) NOT NULL,
    flagged                  NUMBER(1) DEFAULT 1 NOT NULL,
    branch_branchid          NUMBER(3) NOT NULL,
    classification_classid   NUMBER(1) NOT NULL
);

ALTER TABLE burrower ADD CONSTRAINT burrower_pk PRIMARY KEY ( burrowerid );

CREATE TABLE classification (
    classid   NUMBER(1) NOT NULL,
    class     VARCHAR2(12) NOT NULL
);

ALTER TABLE classification
    ADD CHECK ( class IN (
        'Adult',
        'Junior',
        'Organisation'
    ) );

ALTER TABLE classification ADD CONSTRAINT classification_pk PRIMARY KEY ( classid );

CREATE TABLE fictionnumber (
    fictionnumber   NUMBER(2) NOT NULL,
    title_callno    VARCHAR2(20) NOT NULL
);

ALTER TABLE fictionnumber
    ADD CHECK ( fictionnumber IN (
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
        22,
        23,
        24,
        25,
        26,
        27,
        28,
        29,
        30
    ) );

ALTER TABLE fictionnumber ADD CONSTRAINT fictionnumber_pk PRIMARY KEY ( title_callno );

CREATE TABLE identifier (
    isbn           VARCHAR2(50) NOT NULL,
    title_callno   VARCHAR2(20) NOT NULL
);

ALTER TABLE identifier ADD CONSTRAINT identifier_pk PRIMARY KEY ( isbn );

CREATE TABLE latedelivery (
    paymentdate                DATE NOT NULL,
    amount                     NUMBER(8,2) NOT NULL,
    loan_loanid                NUMBER(20) NOT NULL,
    loan_burrower_burrowerid   NUMBER(10) NOT NULL,
    loan_title_callno          VARCHAR2(20) NOT NULL
);

ALTER TABLE latedelivery
    ADD CONSTRAINT latedelivery_pk PRIMARY KEY ( loan_loanid,
    loan_burrower_burrowerid,
    loan_title_callno );

CREATE TABLE loan (
    loanid                NUMBER(20) NOT NULL,
    loandate              DATE NOT NULL,
    duedate               DATE NOT NULL,
    returndate            DATE NOT NULL,
    burrower_burrowerid   NUMBER(10) NOT NULL,
    title_callno          VARCHAR2(20) NOT NULL
);

ALTER TABLE loan
    ADD CONSTRAINT loan_pk PRIMARY KEY ( loanid,
    burrower_burrowerid,
    title_callno );

CREATE TABLE manager (
    managerid         NUMBER(10) NOT NULL,
    managername       VARCHAR2(25) NOT NULL,
    managersurname    VARCHAR2(50) NOT NULL,
    managerphone      VARCHAR2(13) NOT NULL,
    branch_branchid   NUMBER(3) NOT NULL
);

ALTER TABLE manager ADD CONSTRAINT manager_pk PRIMARY KEY ( managerid );

CREATE TABLE publisher (
    publisherid     NUMBER(10) NOT NULL,
    publishername   VARCHAR2(100) NOT NULL
);

ALTER TABLE publisher ADD CONSTRAINT publisher_pk PRIMARY KEY ( publisherid );

CREATE TABLE reserve (
    reservationdate       DATE NOT NULL,
    burrower_burrowerid   NUMBER(10) NOT NULL,
    bookcopy_barcodeno    NUMBER(20) NOT NULL
);

ALTER TABLE reserve ADD CONSTRAINT reserve_pk PRIMARY KEY ( burrower_burrowerid,
bookcopy_barcodeno );

CREATE TABLE subject (
    subjectname   VARCHAR2(100) NOT NULL
);

ALTER TABLE subject ADD CONSTRAINT subject_pk PRIMARY KEY ( subjectname );

CREATE TABLE subjecttitle (
    title_callno          VARCHAR2(20) NOT NULL,
    subject_subjectname   VARCHAR2(100) NOT NULL
);

ALTER TABLE subjecttitle ADD CONSTRAINT subjecttitle_pk PRIMARY KEY ( title_callno,
subject_subjectname );

CREATE TABLE title (
    callno                  VARCHAR2(20) NOT NULL,
    title                   VARCHAR2(100) NOT NULL,
    description             VARCHAR2(1000) NOT NULL,
    publishyear             NUMBER(4) NOT NULL,
    edition                 VARCHAR2(20) NOT NULL,
    notes                   VARCHAR2(200) NOT NULL,
    language                VARCHAR2(50),
    pageno                  NUMBER(6) NOT NULL,
    classification          VARCHAR2(9) NOT NULL,
    publisher_publisherid   NUMBER(10) NOT NULL
);

ALTER TABLE title
    ADD CHECK ( classification IN (
        'Fiction',
        'Reference'
    ) );

ALTER TABLE title ADD CONSTRAINT title_pk PRIMARY KEY ( callno );

ALTER TABLE authortitle
    ADD CONSTRAINT authortitle_author_fk FOREIGN KEY ( author_authorid )
        REFERENCES author ( authorid );

ALTER TABLE authortitle
    ADD CONSTRAINT authortitle_title_fk FOREIGN KEY ( title_callno )
        REFERENCES title ( callno );

ALTER TABLE bookcopy
    ADD CONSTRAINT bookcopy_branch_fk FOREIGN KEY ( branch_branchid )
        REFERENCES branch ( branchid );

ALTER TABLE bookcopy
    ADD CONSTRAINT bookcopy_identifier_fk FOREIGN KEY ( identifier_isbn )
        REFERENCES identifier ( isbn );

ALTER TABLE branch
    ADD CONSTRAINT branch_manager_fk FOREIGN KEY ( manager_managerid )
        REFERENCES manager ( managerid );

ALTER TABLE burrower
    ADD CONSTRAINT burrower_branch_fk FOREIGN KEY ( branch_branchid )
        REFERENCES branch ( branchid );

ALTER TABLE burrower
    ADD CONSTRAINT burrower_classification_fk FOREIGN KEY ( classification_classid )
        REFERENCES classification ( classid );

ALTER TABLE fictionnumber
    ADD CONSTRAINT fictionnumber_title_fk FOREIGN KEY ( title_callno )
        REFERENCES title ( callno );

ALTER TABLE identifier
    ADD CONSTRAINT identifier_title_fk FOREIGN KEY ( title_callno )
        REFERENCES title ( callno );

ALTER TABLE latedelivery
    ADD CONSTRAINT latedelivery_loan_fk FOREIGN KEY ( loan_loanid,
    loan_burrower_burrowerid,
    loan_title_callno )
        REFERENCES loan ( loanid,
        burrower_burrowerid,
        title_callno );

ALTER TABLE loan
    ADD CONSTRAINT loan_burrower_fk FOREIGN KEY ( burrower_burrowerid )
        REFERENCES burrower ( burrowerid );

ALTER TABLE loan
    ADD CONSTRAINT loan_title_fk FOREIGN KEY ( title_callno )
        REFERENCES title ( callno );

ALTER TABLE manager
    ADD CONSTRAINT manager_branch_fk FOREIGN KEY ( branch_branchid )
        REFERENCES branch ( branchid );

ALTER TABLE reserve
    ADD CONSTRAINT reserve_bookcopy_fk FOREIGN KEY ( bookcopy_barcodeno )
        REFERENCES bookcopy ( barcodeno );

ALTER TABLE reserve
    ADD CONSTRAINT reserve_burrower_fk FOREIGN KEY ( burrower_burrowerid )
        REFERENCES burrower ( burrowerid );

ALTER TABLE subjecttitle
    ADD CONSTRAINT subjecttitle_subject_fk FOREIGN KEY ( subject_subjectname )
        REFERENCES subject ( subjectname );

ALTER TABLE subjecttitle
    ADD CONSTRAINT subjecttitle_title_fk FOREIGN KEY ( title_callno )
        REFERENCES title ( callno );

ALTER TABLE title
    ADD CONSTRAINT title_publisher_fk FOREIGN KEY ( publisher_publisherid )
        REFERENCES publisher ( publisherid );

CREATE SEQUENCE branchid_seq START WITH 100 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER branchid_trig BEFORE
    INSERT ON branch
    FOR EACH ROW
BEGIN
    :new.branchid := branchid_seq.nextval;
END;
