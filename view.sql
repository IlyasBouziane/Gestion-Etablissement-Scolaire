create or replace view materiel_emprunte as
    select id_categorie, id_frs, id_stock, produit.id_produit, designation_produit, reference_materiel, id_stock_emprunteur
     from materiel, produit, emprunt
     where produit.id_produit = materiel.id_produit
     and materiel.reference_materiel = emprunt.ref_materiel_emprunte
     and materiel.reference_materiel in 
        (select reference_materiel from emprunt, materiel 
         where emprunt.ref_materiel_emprunte = materiel.reference_materiel
         and emprunt.date_retour is null)
     order by emprunt.date_emprunt;


create view materiel_du_dpt as
    select id_categorie, id_stock, id_frs, produit.id_produit, designation_produit, reference_materiel
     from produit, materiel
     where produit.id_produit = materiel.id_produit
     order by designation_produit;
     

create view produit_detail as 
  select produit.id_produit, reference_materiel, date_entree, id_stock, designation_etat
  from etat, materiel, produit
  where etat.id_etat = materiel.id_etat 
  and materiel.id_produit = produit.id_produit
  order by materiel.date_entree;

create view produit_detail_materiel as
  select produit.id_produit, designation_produit, prixht_produit, tva_produit,nom_frs, designation_categorie
  from produit, fournisseur, categorie
  where produit.id_frs = fournisseur.id_frs and produit.id_categorie = categorie.id_categorie;
  
create or replace view demandes_emprunts_deposes as
  select id_demande, date_depos_demande, qte_demande, produit.id_produit, 
    designation_produit, id_resp 
    from produit, demande
    where produit.id_produit = demande.id_produit
    and type_demande = 'EMPRUNT'
    order by date_depos_demande;
    
create or replace view commandes_deposes as 
  select demande.id_demande, date_depos_demande, qte_demande, produit.id_produit, 
    designation_produit, id_resp, etat_suivi, id_commande
  from demande, produit, commande
  where demande.id_produit = produit.id_produit 
  and demande.id_demande = commande.id_demande
  and type_demande = 'AFFECTATION'
  order by date_depos_demande;