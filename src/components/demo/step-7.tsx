import React from 'react';
import { Text } from '@components/index';

export const Step7 = () => {
	return (
		<>
			<Text color="primary">Step 7</Text>
			<div
				style={{
					height: 300,
					width: '100%',
					borderRadius: '12px 12px 0 0',
					display: 'flex',
					justifyContent: 'center',
					alignItems: 'center',
					background:
						'linear-gradient(90deg,#f4f5f7 11px,transparent 1%) 50%,linear-gradient(#f4f5f7 11px,transparent 1%) 50%,#bbc1d3',
					backgroundSize: '12px 12px',
					overflow: 'hidden',
					whiteSpace: 'normal',
				}}
			>
				<div style={{ height: 50, width: 50, backgroundColor: 'white' }} />
			</div>
		</>
	);
};
