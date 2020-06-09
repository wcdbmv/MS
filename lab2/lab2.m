function lab2()
	X = [-8.47, -7.45, -7.12, -8.30, -8.15, -6.01, -5.20, -7.38, -6.76, -9.18, -6.00, -8.08, -7.96, -8.34, -6.82, -8.46, -8.07, -7.04, -7.24, -8.16, -8.20, -8.27, -7.79, -7.37, -7.02, -7.13, -6.99, -7.65, -8.18, -6.71, -8.41, -6.71, -7.04, -9.15, -7.74, -10.11, -8.20, -7.07, -7.63, -8.99, -6.62, -6.23, -7.13, -6.41, -7.06, -7.72, -8.44, -8.85, -8.02, -6.98, -6.08, -7.20, -7.48, -7.82, -9.19, -8.31, -7.95, -7.97, -6.66, -6.59, -9.10, -7.87, -9.02, -8.77, -7.62, -9.44, -8.05, -7.60, -7.33, -6.94, -8.51, -7.39, -6.44, -8.88, -8.21, -7.66, -6.91, -8.39, -7.37, -7.26, -6.04, -7.58, -7.28, -7.02, -7.10, -7.33, -8.63, -8.21, -7.12, -8.11, -9.03, -8.11, -8.79, -9.22, -7.32, -5.97, -7.26, -6.39, -7.64, -8.38, -7.67, -7.70, -7.70, -8.95, -6.25, -8.09, -7.85, -8.10, -7.73, -6.78, -7.78, -8.20, -8.88, -8.51, -7.45, -7.14, -6.63, -7.38, -7.72, -6.25];

	gamma = 0.9;

	% 1) и 2)
	[muhat, sigmahat, muci, sigmaci] = normfit(X, 1 - gamma);
	S2 = sigmahat ^ 2;
	sigmaci2 = sigmaci .^ 2;
	fprintf('muhat = %f, S^2 = %f\n', muhat, S2);
	fprintf('muci = (%f; %f)\n', muci(1), muci(2));
	fprintf('sigmaci = (%f; %f)\n', sigmaci2(1), sigmaci2(2));

	% 3)
	graphmuhat(X, gamma, muhat);
	graphS2(X, gamma, S2);
end

function [muhat, muci] = normfitmu(X, alpha)
	% Границы доверительного интервала для математического ожидания
	[muhat, ~, muci, ~] = normfit(X, alpha);
end

function [sigmahat2, sigmaci2] = normfitsigma2(X, alpha)
	% Границы доверительного интервала для дисперсии
	[~, sigmahat, ~, sigmaci] = normfit(X, alpha);
	sigmahat2 = sigmahat ^ 2;
	sigmaci2 = sigmaci .^ 2;
end

function graph(X, gamma, est, fit, label_line, label_est, label_over, label_under)
	% Построение графиков
	%	X - генеральная совокупность
	%	gamma - уровень доверия
	%	est - точечная оценка
	%	fit - функция точечной оценки и границ
	%	label_line  - подпись к графику точечной оценки от x_N
	%	label_est   - подпись к графику точечной оценки от x_n
	%	label_over  - подпись к графику верхней границы от x_n
	%	label_under - подпись к графику нижней границы от x_n

	N = length(X);

	figure
	plot([10, N], [est, est]);
	hold on;
	grid on;

	ests = zeros(1, N);
	cis = zeros(2, N);

	for n = 10:N
		[ests(n), cis(:, n)] = fit(X(1:n), 1 - gamma);
	end

	plot(10:N, ests(10:N));
	plot(10:N, cis(1, 10:N));
	plot(10:N, cis(2, 10:N));

	l = legend(label_line, label_est, label_over, label_under);
	set(l, 'Interpreter', 'latex', 'fontsize', 14);
	hold off;
end

function graphmuhat(X, gamma, muhat)
	graph(X, gamma, muhat, @normfitmu, '$\mu(\vec x_N)$', '$\mu(\vec x_n)$', '$\underline\mu(\vec x_n)$', '$\overline\mu(\vec x_n)$');
end

function graphS2(X, gamma, S2)
	graph(X, gamma, S2, @normfitsigma2, '$\sigma(\vec x_N)$', '$\sigma(\vec x_n)$', '$\underline\sigma(\vec x_n)$', '$\overline\sigma(\vec x_n)$');
end
