import React from 'react';
import { styled } from '@stitches/react';
import { motion } from 'framer-motion';

export const Card = styled(motion.div, {
	display: 'flex',
	alignItems: 'center',
	justifyContent: 'space-between',
	borderRadius: '$2',
	padding: '$4',
	marginBottom: '16px',
	variants: {
		toggle: {
			on: {
				border: '1px solid $mauve9',
				color: '$mauve12',
				boxShadow: '0 0 16px 0 $colors$violetA9',
			},
			off: {
				border: '1px solid $mauve6',
				color: '$mauve11',
			},
		},
	},
	defaultVariants: {
		toggle: 'off',
	},
});
