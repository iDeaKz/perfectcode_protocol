```typescript
/**
 * Production Deployment Configuration
 * Military-grade infrastructure setup
 */

export const PRODUCTION_CONFIG = {
  // Cloudflare Workers configuration
  cloudflare: {
    workers: [
      {
        name: 'perfect-generator-v1',
        script: 'cloudflare-workers/perfect-worker.ts',
        size: 10240, // Exactly 10kb
        routes: ['api.perfectcode.com/generate/*'],
        environment: 'production'
      },
      {
        name: 'error-handler-v1', 
        script: 'cloudflare-workers/error-handler.ts',
        size: 9847,
        routes: ['api.perfectcode.com/errors/*'],
        environment: 'production'
      }
    ],
    
    durableObjects: [
      {
        name: 'GenerationState',
        class: 'GenerationStateManager',
        script: 'perfect-generator-v1'
      }
    ],
    
    kv: [
      {
        binding: 'TEMPLATES',
        namespace: 'perfect-templates-prod'
      },
      {
        binding: 'CACHE',
        namespace: 'optimization-cache-prod'
      }
    ]
  },

  // Kubernetes configuration
  kubernetes: {
    namespace: 'perfectcode-production',
    services: [
      {
        name: 'generator-service',
        replicas: 5,
        image: 'perfectcode/generator:latest',
        resources: {
          requests: { cpu: '500m', memory: '1Gi' },
          limits: { cpu: '2', memory: '4Gi' }
        }
      },
      {
        name: 'error-handler-service',
        replicas: 7,
        image: 'perfectcode/error-handler:latest', 
        resources: {
          requests: { cpu: '200m', memory: '512Mi' },
          limits: { cpu: '1', memory: '2Gi' }
        }
      }
    ]
  },

  // Monitoring configuration
  monitoring: {
    prometheus: {
      enabled: true,
      retention: '30d',
      alerts: 'military-grade-alerts.yaml'
    },
    grafana: {
      enabled: true,
      dashboards: ['perfectcode-overview', 'error-handling', '10kb-precision']
    }
  }
};
```