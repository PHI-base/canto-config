SELECT strain_id, value, scientific_name, strain_name
FROM strain
INNER JOIN organism
  ON organism.organism_id = strain.organism_id
INNER JOIN organismprop
  ON organismprop.organism_id = strain.organism_id;
