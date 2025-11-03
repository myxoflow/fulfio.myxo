module.exports = function (ctx) {
  return {
    supportTS: {
      tsCheckerConfig: {
        eslint: {
          enabled: true,
          files: './src/**/*.{ts,tsx,js,jsx,vue}'
        }
      }
    },
    boot: ['pinia'], // Add this line
    css: ['app.scss'],
    extras: ['roboto-font', 'material-icons'],
    build: {
      vueRouterMode: 'history',
      extendWebpack(cfg) {
        cfg.resolve.extensions.push('.ts', '.tsx')
      },
      env: {
        API_URL: process.env.VUE_APP_API_URL || 'http://localhost:3000',
        STORJ_GATEWAY: process.env.VUE_APP_STORJ_GATEWAY || 'https://gateway.storjshare.io'
      }
    },
    devServer: {
      server: { type: 'http' },
      port: 8080,
      open: true
    },
    framework: {
      config: {},
      plugins: ['Notify', 'Dialog', 'Loading']
    }
  }
}