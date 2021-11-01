import React from 'react';
import { styled } from '@stitches/react';
import { motion } from 'framer-motion';
import { Flex } from '@components/index';
// @ts-expect-error TODO fix types
import { send } from '../../utils/wags/handoff';

const MotionGlitch = styled(motion.div, {
	height: 80,
	width: 80,
	borderRadius: '$2',
	backgroundColor: '$violet8',
	opacity: 0.25,
	boxShadow: '0 0 16px 0 $colors$violetA9',
	webKitTouchCallout: 'none',
	webkitTextSizeAdjust: 'none',
	webKitUserSelect: 'none',
	userSelect: 'none',
});

export const Step6 = ({
	demoInitialized,
}: {
	demoInitialized: DemoInitialized;
}) => {
	const sendr = (event: Boolean) =>
		send(demoInitialized)({
			tag: "DE'The_possibility_to_glitch_crackle_and_shimmer",
			event,
		});
	return (
		<Flex
			justify="center"
			align="center"
			css={{
				margin: 128,
			}}
		>
			<MotionGlitch
				onTapStart={sendr(true)}
				onTap={sendr(false)}
				onTapCancel={sendr(false)}
				whileTap={{
					scale: 4,
					x: [
						0, 10, -10, 10, -10, 10, -10, 10, -10, 10, -10, 10, -10, 10, -10,
						10, -10, 10, -10, 10, -10, 10, -10, 10, -10, 10, -10, 10, -10, 10,
						-10, 10, -10, 10, -10, 10, -10, 0,
					],
					opacity: 1,
				}}
				transition={{ duration: 2 }}
			/>
		</Flex>
	);
};
