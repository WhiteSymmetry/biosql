--
-- API Package Body for Ontology_Term_Assoc.
--
-- Scaffold auto-generated by gen-api.pl (H.Lapp, 2002).
--
-- $Id: Ontology_Term_Assoc.pkb,v 1.1.1.2 2003-01-29 08:54:39 lapp Exp $
--

--
-- Copyright 2002-2003 Genomics Institute of the Novartis Research Foundation
-- Copyright 2002-2008 Hilmar Lapp
-- 
--  This file is part of BioSQL.
--
--  BioSQL is free software: you can redistribute it and/or modify it
--  under the terms of the GNU Lesser General Public License as
--  published by the Free Software Foundation, either version 3 of the
--  License, or (at your option) any later version.
--
--  BioSQL is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Lesser General Public License for more details.
--
--  You should have received a copy of the GNU Lesser General Public License
--  along with BioSQL. If not, see <http://www.gnu.org/licenses/>.
--

CREATE OR REPLACE
PACKAGE BODY OntA IS

CURSOR OntA_c (
		OntA_SRC_ONT_OID  IN SG_ONTOLOGY_TERM_ASSOC.SRC_ONT_OID%TYPE,
		OntA_TYPE_ONT_OID IN SG_ONTOLOGY_TERM_ASSOC.TYPE_ONT_OID%TYPE,
		OntA_TGT_ONT_OID  IN SG_ONTOLOGY_TERM_ASSOC.TGT_ONT_OID%TYPE)
RETURN SG_ONTOLOGY_TERM_ASSOC%ROWTYPE IS
	SELECT t.* FROM SG_ONTOLOGY_TERM_ASSOC t
	WHERE
		t.Src_ONT_OID = OntA_SRC_ONT_OID
	AND     t.Type_ONT_OID = OntA_TYPE_ONT_OID
	AND     t.Tgt_ONT_OID = OntA_TGT_ONT_OID
	;

FUNCTION get_oid(
		SRC_ONT_OID IN SG_ONTOLOGY_TERM_ASSOC.SRC_ONT_OID%TYPE DEFAULT NULL,
		TYPE_ONT_OID	IN SG_ONTOLOGY_TERM_ASSOC.TYPE_ONT_OID%TYPE DEFAULT NULL,
		TGT_ONT_OID	IN SG_ONTOLOGY_TERM_ASSOC.TGT_ONT_OID%TYPE DEFAULT NULL,
		Src_Ont_NAME	IN SG_ONTOLOGY_TERM.NAME%TYPE DEFAULT NULL,
		Src_Cat_OID	IN SG_ONTOLOGY_TERM.ONT_OID%TYPE DEFAULT NULL,
		Src_Ont_IDENTIFIER	IN SG_ONTOLOGY_TERM.IDENTIFIER%TYPE DEFAULT NULL,
		Type_Ont_NAME	IN SG_ONTOLOGY_TERM.NAME%TYPE DEFAULT NULL,
		Type_Cat_OID	IN SG_ONTOLOGY_TERM.ONT_OID%TYPE DEFAULT NULL,
		Type_Ont_IDENTIFIER	IN SG_ONTOLOGY_TERM.IDENTIFIER%TYPE DEFAULT NULL,
		Tgt_Ont_NAME	IN SG_ONTOLOGY_TERM.NAME%TYPE DEFAULT NULL,
		Tgt_Cat_OID	IN SG_ONTOLOGY_TERM.ONT_OID%TYPE DEFAULT NULL,
		Tgt_Ont_IDENTIFIER	IN SG_ONTOLOGY_TERM.IDENTIFIER%TYPE DEFAULT NULL,
		do_DML		IN NUMBER DEFAULT BSStd.DML_NO)
RETURN INTEGER
IS
	pk	INTEGER DEFAULT NULL;
	OntA_row OntA_c%ROWTYPE;
	SRC_ONT_OID_	SG_ONTOLOGY_TERM.OID%TYPE DEFAULT SRC_ONT_OID;
	TGT_ONT_OID_	SG_ONTOLOGY_TERM.OID%TYPE DEFAULT TGT_ONT_OID;
	TYPE_ONT_OID_	SG_ONTOLOGY_TERM.OID%TYPE DEFAULT TYPE_ONT_OID;
BEGIN
	-- look up SG_ONTOLOGY_TERM
	IF (SRC_ONT_OID_ IS NULL) THEN
		SRC_ONT_OID_ := Ont.get_oid(
				Ont_NAME => Src_Ont_NAME,
				Ont_CAT_OID => Src_CAT_OID,
				Ont_IDENTIFIER => Src_Ont_IDENTIFIER,
				do_DML => do_DML);
	END IF;
	-- look up SG_ONTOLOGY_TERM
	IF (TGT_ONT_OID_ IS NULL) THEN
		TGT_ONT_OID_ := Ont.get_oid(
				Ont_NAME => Tgt_Ont_NAME,
				Ont_CAT_OID => Tgt_CAT_OID,
				Ont_IDENTIFIER => Tgt_Ont_IDENTIFIER,
				do_DML => do_DML);
	END IF;
	-- look up SG_ONTOLOGY_TERM
	IF (TYPE_ONT_OID_ IS NULL) THEN
		TYPE_ONT_OID_ := Ont.get_oid(
				Ont_NAME => Type_Ont_NAME,
				Ont_CAT_OID => Type_CAT_OID,
				Ont_IDENTIFIER => Type_Ont_IDENTIFIER,
				do_DML => do_DML);
	END IF;
	-- look up
	FOR OntA_row IN OntA_c (Src_Ont_Oid_, Type_Ont_Oid_, Tgt_Ont_Oid_) LOOP
	        pk := 1;
	END LOOP;
	-- insert if requested (no update)
	IF (pk IS NULL) AND 
	   ((do_DML = BSStd.DML_I) OR (do_DML = BSStd.DML_UI)) THEN
	    	-- look up foreign keys if not provided:
		-- look up source SG_ONTOLOGY_TERM successful?
		IF (SRC_ONT_OID_ IS NULL) THEN
			raise_application_error(-20101,
				'failed to look up Ont <' || Src_Ont_NAME || '|' || Src_CAT_OID || '|' || Src_Ont_IDENTIFIER || '>');
		END IF;
		-- look up target SG_ONTOLOGY_TERM successful?
		IF (TGT_ONT_OID_ IS NULL) THEN
			raise_application_error(-20101,
				'failed to look up Ont <' || Tgt_Ont_NAME || '|' || Tgt_CAT_OID || '|' || Tgt_Ont_IDENTIFIER || '>');
		END IF;
		-- look up type SG_ONTOLOGY_TERM successful?
		IF (TYPE_ONT_OID_ IS NULL) THEN
			raise_application_error(-20101,
				'failed to look up Ont <' || Type_Ont_NAME || '|' || Type_CAT_OID || '|' || Type_Ont_IDENTIFIER || '>');
		END IF;
	    	-- insert the record and obtain the primary key
	    	pk := do_insert(
		        SRC_ONT_OID => SRC_ONT_OID_,
		        TYPE_ONT_OID => TYPE_ONT_OID_,
			TGT_ONT_OID => TGT_ONT_OID_);
	END IF;
	-- return the primary key
	RETURN pk;
END;

FUNCTION do_insert(
		SRC_ONT_OID	IN SG_ONTOLOGY_TERM_ASSOC.SRC_ONT_OID%TYPE,
		TYPE_ONT_OID	IN SG_ONTOLOGY_TERM_ASSOC.TYPE_ONT_OID%TYPE,
		TGT_ONT_OID	IN SG_ONTOLOGY_TERM_ASSOC.TGT_ONT_OID%TYPE)
RETURN INTEGER
IS
BEGIN
	-- insert the record
	INSERT INTO SG_ONTOLOGY_TERM_ASSOC (
		SRC_ONT_OID,
		TYPE_ONT_OID,
		TGT_ONT_OID)
	VALUES (SRC_ONT_OID,
		TYPE_ONT_OID,
		TGT_ONT_OID)
	;
	-- return TRUE
	RETURN 1;
END;

END OntA;
/

