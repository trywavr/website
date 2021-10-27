/** @type {import('next').NextConfig} */
const withPWA = require('next-pwa');

module.exports = withPWA({
	swcMinify: true,
	pwa: {
		dest: 'public',
		disable: process.env.NODE_ENV === 'development',
	},
	reactStrictMode: true,
	images: {
		domains: ['upload.wikimedia.org'],
	},
});
