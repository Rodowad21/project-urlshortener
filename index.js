require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const dns = require('dns');
const { URL } = require('url');
const supabase = require('./supabaseClient');
const app = express();

// Basic Configuration
const port = process.env.PORT || 3000;

app.use(cors());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use('/public', express.static(`${process.cwd()}/public`));

app.get('/', function(req, res) {
  res.sendFile(process.cwd() + '/views/index.html');
});

// Your first API endpoint
app.get('/api/hello', function(req, res) {
  res.json({ greeting: 'hello API' });
});

// POST /api/shorturl - Create a shortened URL
app.post('/api/shorturl', async function(req, res) {
  const originalUrl = req.body.url;

  // Validate URL format
  let parsedUrl;
  try {
    parsedUrl = new URL(originalUrl);

    // Only allow http and https protocols
    if (parsedUrl.protocol !== 'http:' && parsedUrl.protocol !== 'https:') {
      return res.json({ error: 'invalid url' });
    }
  } catch (err) {
    return res.json({ error: 'invalid url' });
  }

  // Verify the hostname exists using dns.lookup
  dns.lookup(parsedUrl.hostname, async (err) => {
    if (err) {
      return res.json({ error: 'invalid url' });
    }

    // Insert URL into database
    const { data, error } = await supabase
      .from('urls')
      .insert([{ original_url: originalUrl }])
      .select()
      .maybeSingle();

    if (error || !data) {
      return res.json({ error: 'database error' });
    }

    res.json({
      original_url: data.original_url,
      short_url: data.id
    });
  });
});

// GET /api/shorturl/:short_url - Redirect to original URL
app.get('/api/shorturl/:short_url', async function(req, res) {
  const shortUrl = req.params.short_url;

  // Query database for the original URL
  const { data, error } = await supabase
    .from('urls')
    .select('original_url')
    .eq('id', shortUrl)
    .maybeSingle();

  if (error || !data) {
    return res.json({ error: 'No short URL found' });
  }

  // Redirect to the original URL
  res.redirect(data.original_url);
});

app.listen(port, function() {
  console.log(`Listening on port ${port}`);
});
