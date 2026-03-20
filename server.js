const express = require('express');
const app     = express();
app.use(express.json());
 
const PORT    = process.env.PORT        || 3000;
const ENV     = process.env.NODE_ENV    || 'development';
const VERSION = process.env.APP_VERSION || '1.0.0';
 
// Health check — Jenkins calls this to verify the deployment worked
app.get('/health', (req, res) => {
  res.json({ status: 'OK', environment: ENV, version: VERSION, timestamp: new Date().toISOString() });
});
 
// Home page
app.get('/', (req, res) => {
  res.json({ message: `Hello from ${ENV}!`, version: VERSION, environment: ENV });
});
 
// API info
app.get('/api/info', (req, res) => {
  res.json({ app: 'Secure CI/CD Demo', environment: ENV, version: VERSION,
             node: process.version, uptime: Math.floor(process.uptime()) + 's' });
});
 
// 404
app.use((req, res) => { res.status(404).json({ error: 'Not Found', path: req.path }); });
 
// Only start server if run directly (not during tests)
if (require.main === module) {
  app.listen(PORT, () => console.log(`App running on port ${PORT} in ${ENV} mode`));
}
 
module.exports = app;   // Export for testing
