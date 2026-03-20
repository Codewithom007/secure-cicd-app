const request = require('supertest');
const app     = require('./server');
 
describe('API Endpoints', () => {
 
  test('GET /health returns 200 with status OK', async () => {
    const res = await request(app).get('/health');
    expect(res.statusCode).toBe(200);
    expect(res.body.status).toBe('OK');
    expect(res.body).toHaveProperty('environment');
    expect(res.body).toHaveProperty('timestamp');
  });
 
  test('GET / returns greeting message', async () => {
    const res = await request(app).get('/');
    expect(res.statusCode).toBe(200);
    expect(res.body.message).toContain('Hello from');
  });
 
  test('GET /api/info returns app details', async () => {
    const res = await request(app).get('/api/info');
    expect(res.statusCode).toBe(200);
    expect(res.body.app).toBe('Secure CI/CD Demo');
  });
 
  test('GET /unknown returns 404', async () => {
    const res = await request(app).get('/unknown');
    expect(res.statusCode).toBe(404);
    expect(res.body).toHaveProperty('error');
  });
 
});
