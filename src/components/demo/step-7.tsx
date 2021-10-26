import React, { useRef } from 'react';
import { styled } from '@stitches/react';
import { Text } from '@components/index';
import { motion } from 'framer-motion';

const MotionContainer = styled(motion.div, {
	height: 300,
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
	cursor: 'grab',
	'&:active': {
		cursor: 'grabbing',
		boxShadow: '0 0 16px 0 $colors$violetA10',
	},
});

export const Step7 = () => {
	const constraintsRef = useRef(null);
	return (
		<>
			<MotionContainer ref={constraintsRef}>
				<MotionHandle
					drag
					onDrag={(event, info) =>
						console.log(event, info.point.x, info.point.y)
					}
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
