--
-- API Package Body for DB_Release.
--
-- Scaffold auto-generated by gen-api.pl (H.Lapp, 2002).
--
-- $Id: DB_Release.pkb,v 1.1.1.1 2002-08-13 19:51:10 lapp Exp $
--

--
-- (c) Hilmar Lapp, hlapp at gnf.org, 2002.
-- (c) GNF, Genomics Institute of the Novartis Research Foundation, 2002.
--
-- You may distribute this module under the same terms as Perl.
-- Refer to the Perl Artistic License (see the license accompanying this
-- software package, or see http://www.perl.com/language/misc/Artistic.html)
-- for the terms under which you may use, modify, and redistribute this module.
-- 
-- THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
-- WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
-- MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
--

CREATE OR REPLACE
PACKAGE BODY Rel IS

Rel_cached	SG_DB_RELEASE.OID%TYPE DEFAULT NULL;
cache_key		VARCHAR2(128) DEFAULT NULL;

CURSOR Rel_c (
		Rel_VERSION	IN SG_DB_RELEASE.VERSION%TYPE,
		Rel_DB_OID	IN SG_DB_RELEASE.DB_OID%TYPE)
RETURN SG_DB_RELEASE%ROWTYPE IS
	SELECT t.* FROM SG_DB_RELEASE t
	WHERE
		t.VERSION = Rel_VERSION
	AND	t.DB_OID = Rel_DB_OID
	;

FUNCTION get_oid(
		Rel_OID	IN SG_DB_RELEASE.OID%TYPE DEFAULT NULL,
		Rel_VERSION	IN SG_DB_RELEASE.VERSION%TYPE,
		Rel_REL_DATE	IN SG_DB_RELEASE.REL_DATE%TYPE DEFAULT NULL,
		DB_OID	IN SG_DB_RELEASE.DB_OID%TYPE,
		DB_NAME	IN SG_BIODATABASE.NAME%TYPE DEFAULT NULL,
		DB_ACRONYM	IN SG_BIODATABASE.ACRONYM%TYPE DEFAULT NULL,
		do_DML		IN NUMBER DEFAULT BSStd.DML_NO)
RETURN SG_DB_RELEASE.OID%TYPE
IS
	pk	SG_DB_RELEASE.OID%TYPE DEFAULT NULL;
	Rel_row Rel_c%ROWTYPE;
	DB_OID_	SG_BIODATABASE.OID%TYPE DEFAULT DB_OID;
	key_str	VARCHAR2(128) DEFAULT Rel_VERSION || '|' || DB_OID || '|' || DB_NAME || '|' || DB_ACRONYM;
BEGIN
	-- initialize
	IF (do_DML > BSStd.DML_NO) THEN
		pk := Rel_OID;
	END IF;
	-- look up SG_BIODATABASE
	IF (DB_OID_ IS NULL) THEN
		DB_OID_ := DB.get_oid(
				DB_NAME => DB_NAME,
				DB_ACRONYM => DB_ACRONYM);
	END IF;
	-- look up
	IF pk IS NULL THEN
		IF (key_str = cache_key) THEN
			pk := Rel_cached;
		ELSE
			-- reset cache
			cache_key := NULL;
			Rel_cached := NULL;
			-- do the look up
			FOR Rel_row IN Rel_c(Rel_VERSION, DB_OID_) LOOP
		        	pk := Rel_row.OID;
				-- cache result
			    	cache_key := key_str;
			    	Rel_cached := pk;
			END LOOP;
		END IF;
	END IF;
	-- insert/update if requested
	IF (pk IS NULL) AND 
	   ((do_DML = BSStd.DML_I) OR (do_DML = BSStd.DML_UI)) THEN
	    	-- look up foreign keys if not provided:
		-- look up SG_BIODATABASE successful?
		IF (DB_OID_ IS NULL) THEN
			raise_application_error(-20101,
				'failed to look up DB <' || DB_NAME || '|' || DB_ACRONYM || '>');
		END IF;
	    	-- insert the record and obtain the primary key
	    	pk := do_insert(
		        VERSION => Rel_VERSION,
			REL_DATE => Rel_REL_DATE,
			DB_OID => DB_OID_);
	ELSIF (do_DML = BSStd.DML_U) OR (do_DML = BSStd.DML_UI) THEN
	        -- update the record (note that not provided FKs will not
		-- be changed nor looked up)
		do_update(
			Rel_OID	=> pk,
		        Rel_VERSION => Rel_VERSION,
			Rel_REL_DATE => Rel_REL_DATE,
			Rel_DB_OID => DB_OID_);
	END IF;
	-- return the primary key
	RETURN pk;
END;

FUNCTION do_insert(
		VERSION	IN SG_DB_RELEASE.VERSION%TYPE,
		REL_DATE	IN SG_DB_RELEASE.REL_DATE%TYPE,
		DB_OID	IN SG_DB_RELEASE.DB_OID%TYPE)
RETURN SG_DB_RELEASE.OID%TYPE 
IS
	pk	SG_DB_RELEASE.OID%TYPE;
BEGIN
	-- pre-generate the primary key value
	SELECT SG_Sequence.nextval INTO pk FROM DUAL;
	-- insert the record
	INSERT INTO SG_DB_RELEASE (
		OID,
		VERSION,
		REL_DATE,
		DB_OID)
	VALUES (pk,
		VERSION,
		REL_DATE,
		DB_OID)
	;
	-- return the new pk value
	RETURN pk;
END;

PROCEDURE do_update(
		Rel_OID	IN SG_DB_RELEASE.OID%TYPE,
		Rel_VERSION	IN SG_DB_RELEASE.VERSION%TYPE,
		Rel_REL_DATE	IN SG_DB_RELEASE.REL_DATE%TYPE,
		Rel_DB_OID	IN SG_DB_RELEASE.DB_OID%TYPE)
IS
BEGIN
	-- update the record (and leave attributes passed as NULL untouched)
	UPDATE SG_DB_RELEASE
	SET
		VERSION = NVL(Rel_VERSION, VERSION),
		REL_DATE = NVL(Rel_REL_DATE, REL_DATE),
		DB_OID = NVL(Rel_DB_OID, DB_OID)
	WHERE OID = Rel_OID
	;
END;

END Rel;
/
