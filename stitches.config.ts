import { createStitches } from '@stitches/react';
import type * as Stitches from '@stitches/react';
export type { VariantProps } from '@stitches/react';
import {
	mauve,
	mauveA,
	mauveDark,
	mauveDarkA,
	whiteA,
	blackA,
	violet,
	violetA,
	violetDark,
	violetDarkA,
} from '@radix-ui/colors';

export const {
	styled,
	css,
	theme,
	createTheme,
	getCssText,
	globalCss,
	keyframes,
	config,
} = createStitches({
	theme: {
		// color, background-color, border-color
		colors: {
			// 1 App background
			// 2 Subtle background
			// 3 UI element background
			// 4 Hovered UI element background.
			// 5 Active / Selected UI element background.
			// 6 Subtle borders and separators.
			// 7 UI element border and focus rings
			// 8 Hovered UI element border
			// 9 Solid backgrounds.
			// 10 Hovered solid backgrounds.
			// 11 Low-contrast text.
			// 12 High-contrast text.
			...mauve,
			...mauveA,
			...whiteA,
			...blackA,
			...violet,
			...violetA,

			shadowLight: 'hsl(206 22% 7% / 35%)',
			shadowDark: 'hsl(206 22% 7% / 20%)',
		},
		// font-family
		fonts: {
			grotesque: 'Darker Grotesque, sans-serif',
			inter: 'Inter, -apple-system, system-ui, sans-serif',
			mono: 'JetBrains mono, monospace',
		},
		// font-size
		fontSizes: {
			xs: '8px',
			sm: '12px',
			md: '16px',
			lg: '18px',
			xl: '20px',
			'2xl': '24px',
			'3xl': '32px',
			'4xl': '40px',
			'5xl': '48px',
			'6xl': '64px',
		},
		// border-radius
		radii: {
			1: '4px',
			2: '6px',
			3: '8px',
			4: '12px',
			full: '9999px',
		},
		// font-weight
		fontWeights: {
			100: 100,
			200: 200,
			300: 300,
			400: 400,
			500: 500,
			600: 600,
			700: 700,
			800: 800,
			900: 900,
		},
		// margin, margin-top, margin-right, margin-bottom, margin-left, padding, padding-top, padding-right, padding-bottom, padding-left, grid-gap, grid-column-gap, grid-row-gap
		space: {
			px: '1px',
			0.5: '0.125rem',
			1: '0.25rem',
			1.5: '0.375rem',
			2: '0.5rem',
			2.5: '0.625rem',
			3: '0.75rem',
			3.5: '0.875rem',
			4: '1rem',
			5: '1.25rem',
			6: '1.5rem',
			7: '1.75rem',
			8: '2rem',
			9: '2.25rem',
			10: '2.5rem',
			12: '3rem',
			14: '3.5rem',
			16: '4rem',
			20: '5rem',
			24: '6rem',
			28: '7rem',
			32: '8rem',
			36: '9rem',
			40: '10rem',
			44: '11rem',
			48: '12rem',
			52: '13rem',
			56: '14rem',
			60: '15rem',
			64: '16rem',
			72: '18rem',
			80: '20rem',
			96: '24rem',
		},
		// width, height, min-width, max-width, min-height, max-height
		sizes: {
			px: '1px',
			0.5: '0.125rem',
			1: '0.25rem',
			1.5: '0.375rem',
			2: '0.5rem',
			2.5: '0.625rem',
			3: '0.75rem',
			3.5: '0.875rem',
			4: '1rem',
			5: '1.25rem',
			6: '1.5rem',
			7: '1.75rem',
			8: '2rem',
			9: '2.25rem',
			10: '2.5rem',
			12: '3rem',
			14: '3.5rem',
			16: '4rem',
			20: '5rem',
			24: '6rem',
			28: '7rem',
			32: '8rem',
			36: '9rem',
			40: '10rem',
			44: '11rem',
			48: '12rem',
			52: '13rem',
			56: '14rem',
			60: '15rem',
			64: '16rem',
			72: '18rem',
			80: '20rem',
			96: '24rem',
			sm: '30rem',
			md: '48rem',
			lg: '62rem',
			xl: '80rem',
			'2xl': '96rem',
		},
		// box-shadow, text-shadow
		// shadows: {},
		// z-index
		// zIndices: {},
		// transition
		// transitions: {},
		// border-width
		// borderWidths: {},
		// border-style
		// borderStyles: {},
	},
	utils: {
		p: (value: Stitches.PropertyValue<'padding'>) => ({
			padding: value,
		}),
		pt: (value: Stitches.PropertyValue<'paddingTop'>) => ({
			paddingTop: value,
		}),
		pr: (value: Stitches.PropertyValue<'paddingRight'>) => ({
			paddingRight: value,
		}),
		pb: (value: Stitches.PropertyValue<'paddingBottom'>) => ({
			paddingBottom: value,
		}),
		pl: (value: Stitches.PropertyValue<'paddingLeft'>) => ({
			paddingLeft: value,
		}),
		px: (value: Stitches.PropertyValue<'paddingLeft'>) => ({
			paddingLeft: value,
			paddingRight: value,
		}),
		py: (value: Stitches.PropertyValue<'paddingTop'>) => ({
			paddingTop: value,
			paddingBottom: value,
		}),

		m: (value: Stitches.PropertyValue<'margin'>) => ({
			margin: value,
		}),
		mt: (value: Stitches.PropertyValue<'marginTop'>) => ({
			marginTop: value,
		}),
		mr: (value: Stitches.PropertyValue<'marginRight'>) => ({
			marginRight: value,
		}),
		mb: (value: Stitches.PropertyValue<'marginBottom'>) => ({
			marginBottom: value,
		}),
		ml: (value: Stitches.PropertyValue<'marginLeft'>) => ({
			marginLeft: value,
		}),
		mx: (value: Stitches.PropertyValue<'marginLeft'>) => ({
			marginLeft: value,
			marginRight: value,
		}),
		my: (value: Stitches.PropertyValue<'marginTop'>) => ({
			marginTop: value,
			marginBottom: value,
		}),
		br: (value: Stitches.PropertyValue<'borderRadius'>) => ({
			borderRadius: value,
		}),

		size: (value: Stitches.PropertyValue<'width'>) => ({
			width: value,
			height: value,
		}),
	},
});

export type CSS = Stitches.CSS<typeof config>;

export const darkTheme = createTheme('dark-theme', {
	colors: {
		...mauveDark,
		...mauveDarkA,
		...violetDark,
		...violetDarkA,

		shadowLight: 'hsl(206 22% 7% / 35%)',
		shadowDark: 'hsl(206 22% 7% / 20%)',
	},
});

export const globalStyles = globalCss({
	'*, *::before, *::after': {
		boxSizing: 'border-box',
	},
	body: {
		backgroundColor: '$mauve1',
		fontFamily: '$inter',
		scrollBehavior: 'smooth',
		WebkitFontSmoothing: 'antialiased',
		MozOsxFontSmoothing: 'grayscale',
		WebkitTextSizeAdjust: '100%',
		'.dark-theme &': {
			backgroundColor: '$mauve1',
		},
	},
	'h1, h2, h3, h4, h5, h6': {
		fontFamily: '$grotesque',
	},
	'::selection': {
		color: '$violet11',
		background: '$violetA3',
	},
	'pre, code': { margin: 0, fontFamily: '$mono' },
	'#__next': {
		position: 'relative',
		zIndex: 0,
	},
});
