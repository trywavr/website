import { styled } from '../../stitches.config';

export const Text = styled('p', {
	// Reset
	fontFamily: '$inter',
	lineHeight: '1',
	margin: '0',
	fontWeight: 400,
	fontVariantNumeric: 'tabular-nums',
	display: 'block',

	variants: {
		size: {
			xs: {
				fontSize: '$xs',
			},
			sm: {
				fontSize: '$sm',
			},
			md: {
				fontSize: '$md',
			},
			lg: {
				fontSize: '$lg',
			},
			xl: {
				fontSize: '$xl',
				letterSpacing: '-.015em',
			},
			'2xl': {
				fontSize: '$2xl',
				letterSpacing: '-.016em',
			},
			'3xl': {
				fontSize: '$3xl',
				letterSpacing: '-.031em',
				textIndent: '-.005em',
			},
			'4xl': {
				fontSize: '$4xl',
				letterSpacing: '-.034em',
				textIndent: '-.018em',
			},
			'5xl': {
				fontSize: '$5xl',
				letterSpacing: '-.055em',
				textIndent: '-.025em',
			},
		},
		fontWeight: {
			100: {
				fontWeight: "$100",
			},
			200: {
				fontWeight: "$200",
			},
			300: {
				fontWeight: "$300",
			},
			400: {
				fontWeight: "$400",
			},
			500: {
				fontWeight: "$500",
			},
			600: {
				fontWeight: "$600",
			},
			700: {
				fontWeight: "$700",
			},
			800: {
				fontWeight: "$800",
			},
			900: {
				fontWeight: "$900",
			}
		}
	},
	defaultVariants: {
		size: 'md',
		fontWeight: 400
	},
});
