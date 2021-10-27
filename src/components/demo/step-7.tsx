import React, { useRef } from 'react';
import { styled } from '@stitches/react';
import { Text } from '@components/index';
import { motion } from 'framer-motion';
// @ts-expect-error TODO fix types
import { send } from '../../utils/wags/handoff';

const MotionContainer = styled(motion.div, {
	height: 316,
	width: '100%',
	borderRadius: 6,
	display: 'flex',
	justifyContent: 'center',
	alignItems: 'center',
	background:
		'linear-gradient(90deg,$colors$mauve3 11px,transparent 1%) 50%,linear-gradient($colors$mauve3 11px,transparent 1%) 50%,$colors$mauve9',
	backgroundSize: '12px 12px',
	overflow: 'hidden',
	whiteSpace: 'normal',
});

const MotionHandle = styled(motion.div, {
	height: 50,
	width: 50,
	borderRadius: 6,
	background: '$mauve1',
	boxShadow: '0 0 16px 0 $colors$violetA3',
	zIndex: 1,
	transition: 'box-shadow 0.2s',
	cursor: 'grab',
	'&:active': {
		cursor: 'grabbing',
		boxShadow: '0 0 16px 0 $colors$violetA10',
	},
});
const u =
	<T, U>(x: T) =>
	(y: (t: T) => U) =>
		y(x);

const u$ =
	<T,>(x: T | null | undefined) =>
	(y: (t: T) => void) =>
		x && y(x);

const calcSlope =
	(x0: number) => (y0: number) => (x1: number) => (y1: number) => (x: number) =>
		x1 == x0
			? y0
			: y1 == y0
			? y0
			: u((y1 - y0) / (x1 - x0))(m => u(y0 - m * x0)(b => m * x + b));

export const Step7 = ({
	demoInitialized,
}: {
	demoInitialized: DemoInitialized;
}) => {
	const constraintsRef = useRef<HTMLDivElement | null>(null);
	return (
		<>
			<MotionContainer ref={constraintsRef}>
				<MotionHandle
					drag
					onDrag={(event, info) => {
						u$(constraintsRef && constraintsRef.current)(cr => {
							const h = cr.offsetHeight || 0.0;
							const w = cr.offsetWidth || 0.0;
							const t = cr.offsetTop || 0.0;
							const l = cr.offsetLeft || 0.0;
							const packet = {
								tag: "DE'The_possibility_to_shape_it_with_a_gesture",
								event: {
									x: calcSlope(l)(0.0)(l + w)(1.0)(info.point.x),
									y: calcSlope(t)(0.0)(t + h)(1.0)(info.point.y),
								},
							};
							send(demoInitialized)(packet)();
						});
					}}
					dragElastic={0.2}
					dragMomentum={false}
					dragConstraints={constraintsRef}
				/>
			</MotionContainer>
			<Text
				color="tertiary"
				css={{ fontStyle: 'italic', textAlign: 'center', marginTop: 4 }}
			>
				Drag the handle.
			</Text>
		</>
	);
};
