import React from 'react';

const fallbackIcon = {
	path: (
		<g stroke="currentColor" strokeWidth="1.5">
			<path
				strokeLinecap="round"
				fill="none"
				d="M9,9a3,3,0,1,1,4,2.829,1.5,1.5,0,0,0-1,1.415V14.25"
			/>
			<path
				fill="currentColor"
				strokeLinecap="round"
				d="M12,17.25a.375.375,0,1,0,.375.375A.375.375,0,0,0,12,17.25h0"
			/>
			<circle fill="none" strokeMiterlimit="10" cx="12" cy="12" r="11.25" />
		</g>
	),
	viewBox: '0 0 24 24',
};

export const Icon = (props: React.SVGAttributes<SVGElement>) => {
	const {
		viewBox,
		color = 'currentColor',
		height = '1em',
		width = '1em',
		children,
	} = props;

	const styles = {
		display: 'inline-block',
		lineHeight: '1em',
		flexShrink: 0,
		color,
		height,
		width,
	};
	const _viewBox = viewBox ?? fallbackIcon.viewBox;
	const _path = (children ?? fallbackIcon.path) as React.ReactNode;

	return (
		<svg viewBox={_viewBox} style={{ verticalAlign: 'middle', ...styles }}>
			{_path}
		</svg>
	);
};
