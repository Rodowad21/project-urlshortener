/*
  # Create URLs table for URL Shortener

  1. New Tables
    - `urls`
      - `id` (bigserial, primary key) - Used as the short_url identifier
      - `original_url` (text, not null) - The original URL provided by the user
      - `created_at` (timestamptz) - Timestamp when the URL was shortened
  
  2. Security
    - Enable RLS on `urls` table
    - Add policy for public read access (anyone can access shortened URLs)
    - Add policy for public insert access (anyone can create shortened URLs)
  
  3. Notes
    - The `id` field will serve as the short_url number
    - RLS policies allow public access since this is a public URL shortener service
*/

CREATE TABLE IF NOT EXISTS urls (
  id bigserial PRIMARY KEY,
  original_url text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE urls ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read URLs"
  ON urls FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Anyone can create shortened URLs"
  ON urls FOR INSERT
  TO public
  WITH CHECK (true);