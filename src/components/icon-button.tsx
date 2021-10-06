import { styled } from '../../stitches.config';

export const IconButton = styled('button', {
	// Reset
	alignItems: 'center',
	appearance: 'none',
	borderWidth: '0',
	boxSizing: 'border-box',
	display: 'inline-flex',
	flexShrink: 0,
	fontFamily: 'inherit',
	fontSize: '14px',
	justifyContent: 'center',
	lineHeight: '1',
	outline: 'none',
	padding: '0',
	textDecoration: 'none',
	userSelect: 'none',
	WebkitTapHighlightColor: 'transparent',
	color: '$hiContrast',
	'&::before': {
		boxSizing: 'border-box',
	},
	'&::after': {
		boxSizing: 'border-box',
	},
	backgroundColor: '$loContrast',
	border: '1px solid $slate7',
	'&:hover': {
		borderColor: '$slate8',
	},
	'&:active': {
		backgroundColor: '$slate2',
	},
	'&:focus': {
		borderColor: '$slate8',
		boxShadow: '0 0 0 1px $colors$slate8',
	},
	'&:disabled': {
		pointerEvents: 'none',
		backgroundColor: 'transparent',
		color: '$slate6',
	},

	variants: {
		size: {
			'1': {
				borderRadius: '$1',
				height: '$5',
				width: '$5',
			},
			'2': {
				borderRadius: '$2',
				height: '$6',
				width: '$6',
			},
			'3': {
				borderRadius: '$2',
				height: '$7',
				width: '$7',
			},
			'4': {
				borderRadius: '$3',
				height: '$8',
				width: '$8',
			},
		},
		variant: {
			ghost: {
				backgroundColor: 'transparent',
				borderWidth: '0',
				'&:hover': {
					backgroundColor: '$violetA3',
					color: '$violet11',
				},
				'&:focus': {
					boxShadow:
						'inset 0 0 0 1px $colors$violetA8, 0 0 0 1px $colors$violetA8',
				},
				'&:active': {
					backgroundColor: '$violetA4',
				},
			},
			raised: {
				boxShadow:
					'0 0 transparent, 0 16px 32px hsl(206deg 12% 5% / 25%), 0 3px 5px hsl(0deg 0% 0% / 10%)',
				'&:hover': {
					boxShadow:
						'0 0 transparent, 0 16px 32px hsl(206deg 12% 5% / 25%), 0 3px 5px hsl(0deg 0% 0% / 10%)',
				},
				'&:focus': {
					borderColor: '$violet8',
					boxShadow:
						'0 0 0 1px $colors$violet8, 0 16px 32px hsl(206deg 12% 5% / 25%), 0 3px 5px hsl(0deg 0% 0% / 10%)',
				},
				'&:active': {
					backgroundColor: '$violet4',
				},
			},
		},
		state: {
			active: {
				backgroundColor: '$violet4',
				boxShadow: 'inset 0 0 0 1px hsl(206,10%,76%)',
				'@hover': {
					'&:hover': {
						boxShadow: 'inset 0 0 0 1px hsl(206,10%,76%)',
					},
				},
				'&:active': {
					backgroundColor: '$violet4',
				},
			},
			waiting: {
				backgroundColor: '$violet4',
				boxShadow: 'inset 0 0 0 1px hsl(206,10%,76%)',
				'@hover': {
					'&:hover': {
						boxShadow: 'inset 0 0 0 1px hsl(206,10%,76%)',
					},
				},
				'&:active': {
					backgroundColor: '$violet4',
				},
			},
		},
	},
	defaultVariants: {
		size: '1',
		variant: 'ghost',
	},
});
