-- -*-Sql-*- mode (to keep my emacs happy)
--
-- SQL script to create the trigger(s) enabling the load API for
-- SGLD_Bioentry_Qualifier_Assocs.
--
-- Scaffold auto-generated by gen-api.pl.
--
--
-- $GNF: projects/gi/symgene/src/DB/load-trgs/Bioentry_Qualifier_Assocs.trg,v 1.6 2003/05/23 17:42:28 hlapp Exp $
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

CREATE OR REPLACE TRIGGER BIR_Bioentry_Qualifier_Assocs
       INSTEAD OF INSERT
       ON SGLD_Bioentry_Qualifier_Assocs
       REFERENCING NEW AS new OLD AS old
       FOR EACH ROW
DECLARE
	pk		INTEGER;
	do_DML		INTEGER DEFAULT BSStd.DML_I;
BEGIN
	-- do insert 
	pk := EntTrmA.get_oid(
			ENT_OID          => :new.ENT_OID,
		        TRM_OID 	 => :new.TRM_OID,
			EntTrmA_VALUE 	 => :new.EntTrmA_VALUE,
			Ent_ACCESSION 	 => :new.Ent_ACCESSION,
			Ent_VERSION 	 => :new.Ent_VERSION,
			Ent_IDENTIFIER 	 => :new.Ent_IDENTIFIER,
			DB_OID 		 => :new.DB_OID,
			DB_Name 	 => :new.DB_Name,
			DB_Acronym 	 => :new.DB_Acronym,
			Trm_NAME 	 => :new.Trm_NAME,
			ONT_OID 	 => :new.ONT_OID,
			ONT_NAME 	 => :new.ONT_NAME,
			Trm_IDENTIFIER	 => :new.Trm_IDENTIFIER,
			do_DML           => do_DML);
END;
/
