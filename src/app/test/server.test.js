const request = require('supertest');
const app = require('../server');

describe('Sample App API', () => {
  test('GET / should return welcome message', async () => {
    const response = await request(app)
      .get('/')
      .expect(200);
    
    expect(response.body.message).toBe('Welcome to DevOps Sample App');
    expect(response.body.version).toBe('1.0.0');
  });

  test('GET /health should return health status', async () => {
    const response = await request(app)
      .get('/health')
      .expect(200);
    
    expect(response.body.status).toBe('healthy');
    expect(response.body.timestamp).toBeDefined();
    expect(response.body.uptime).toBeDefined();
  });

  test('GET /api should return API data', async () => {
    const response = await request(app)
      .get('/api')
      .expect(200);
    
    expect(response.body.message).toBe('API is working!');
    expect(response.body.data.timestamp).toBeDefined();
    expect(response.body.data.requestId).toBeDefined();
  });

  test('GET /nonexistent should return 404', async () => {
    const response = await request(app)
      .get('/nonexistent')
      .expect(404);
    
    expect(response.body.error).toBe('Route not found');
  });
});
