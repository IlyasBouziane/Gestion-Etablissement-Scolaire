create or replace view  emprunts_recus as
  select id_demande, afficher, date_depos_demande, qte_demande, produit.id_produit, designation_produit, id_stock, nom_stock
  from demande, produit, responsable, stock, occupation occupation0
  where demande.id_produit = produit.id_produit
  and demande.id_resp = responsable.id_resp 
  and occupation0.id_resp_occupant = responsable.id_resp
  and occupation0.id_stock_occupe = stock.id_stock 
  and id_stock = (select occupation1.id_stock_occupe from occupation occupation1
  where id_resp_occupant = responsable.id_resp and occupation1.date_occupation = 
                (select max(occupation2.date_occupation) from occupation occupation2 where occupation2.date_occupation < demande.date_depos_demande))
   and upper(type_demande) = 'EMPRUNT';
               
create or replace view nb_produits_stock as
select count(reference_materiel) nb_materiels,id_stock, id_produit
from materiel where
reference_materiel not in (select ref_materiel_emprunte from emprunt where date_retour is null)
group by id_stock, id_produit;
        
create or replace view approuver_materiels as 
select reference_materiel, id_produit, id_stock ,designation_etat
from materiel, etat          
where  materiel.id_etat=etat.id_etat
and reference_materiel not in (select ref_materiel_emprunte from emprunt where date_retour is null);
  

CREATE OR REPLACE FORCE VIEW  "AFFCTS" ("ID_DEMANDE", "ID_PRODUIT", "NOM_STOCK", "DATE_DEPOS_DEMANDE", "QTE_DEMANDE") AS 
  select d.id_demande,d.id_produit,s.nom_stock,d.date_depos_demande,d.qte_demande from demande d,stock s,occupation o
	where 	d.type_demande = 'AFFECTATION' and
		d.id_produit in (
		select id_produit from materiel where id_produit = 				d.id_produit and  id_stock = 0 and
		(select count(reference_materiel) from materiel where 				id_produit = d.id_produit and id_stock = 0) >=					d.qte_demande ) and
		o.id_resp_occupant = d.id_resp and
		o.date_occupation = ( select max(date_occupation) from occupation where id_resp_occupant = o.id_resp_occupant
and d.date_depos_demande >= date_occupation ) and
		o.id_stock_occupe = s.id_stock
/























