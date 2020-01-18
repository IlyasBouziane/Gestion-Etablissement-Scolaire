create view  emprunts_recus as
  select id_demande, date_depos_demande, qte_demande, produit.id_produit, designation_produit, id_stock, nom_stock
  from demande, produit, responsable, stock, occupation occupation0
  where demande.id_produit = produit.id_produit
  and demande.id_resp = responsable.id_resp 
  and occupation0.id_resp_occupant = responsable.id_resp
  and occupation0.id_stock_occupe = stock.id_stock 
  and id_stock = (select occupation1.id_stock_occupe from occupation occupation1
  where id_resp_occupant = responsable.id_resp and occupation1.date_occupation = 
                (select max(occupation2.date_occupation) from occupation occupation2 where occupation2.date_occupation < demande.date_depos_demande));
        
  