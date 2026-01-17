/*
  # Fix RLS Security Policies

  1. Security Changes
    - Update INSERT policy to use explicit role specification (TO public)
    - Add validation in WITH CHECK clause to ensure original_url is not empty
    - Specify TO public explicitly for all policies
    - Make SELECT policy explicit that it applies to all users

  2. Policy Changes
    - "Anyone can read URLs": SELECT policy for all users (public access)
    - "Anyone can create shortened URLs": INSERT policy with validation for URL content
*/

DROP POLICY IF EXISTS "Anyone can read URLs" ON urls;
DROP POLICY IF EXISTS "Anyone can create shortened URLs" ON urls;

CREATE POLICY "Anyone can read URLs"
  ON urls
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Anyone can create shortened URLs"
  ON urls
  FOR INSERT
  TO public
  WITH CHECK (original_url IS NOT NULL AND length(original_url) > 0);