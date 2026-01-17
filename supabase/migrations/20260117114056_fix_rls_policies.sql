/*
  # Fix RLS Policies for URLs Table

  1. Changes
    - Drop existing overly permissive policies
    - Create new policies with proper checks
    - Public URLs table allows anyone to view shortened URLs
    - Public INSERT requires original_url to be provided
  
  2. Security Notes
    - URLs table is public by design (anyone can create and access shortened URLs)
    - INSERT policy validates that original_url is not null and not empty
    - SELECT policy allows public read access
    - No UPDATE or DELETE allowed to maintain data integrity
*/

DROP POLICY IF EXISTS "Anyone can create shortened URLs" ON urls;
DROP POLICY IF EXISTS "Anyone can read URLs" ON urls;

CREATE POLICY "Anyone can read URLs"
  ON urls FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Public can create shortened URLs"
  ON urls FOR INSERT
  TO public
  WITH CHECK (original_url IS NOT NULL AND original_url != '');